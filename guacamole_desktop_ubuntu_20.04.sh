#/bin/bash

# Because we have to link to the account we ultimately want to use we'll switch straight
# to that at the start rather than using the default ubuntu account

# Create the user we're going to use and make sure their home
# directory is also created since useradd doesn't do this by
# default

sudo useradd -m -G sudo -d /home/student -s /bin/bash student

# Set their password since we don't want a hardcoded password.  To give some
# randomness we'll use the instance ID of the server as the initial password
# so the user can see that in their EC2 console.  The user should still change
# this once they've logged in for the first time.

# We use the AWS link-local HTTP API to retrieve the current instance ID.  This
# will only work on the actual AWS image.  This bit will obviously fail if you're
# not on AWS

export INSTANCE=`curl -s http://169.254.169.254/latest/meta-data/instance-id`
echo student:$INSTANCE | sudo chpasswd

# We now have the student account available to us.  We'll do some basic building in 
# ubuntu but then switch over when we get to VNC stuff.

# Build guacamole from source since there isn't an ubuntu
# package we can use yet.
sudo apt update
sudo apt -y install build-essential libcairo2-dev libjpeg-turbo8-dev libpng-dev libtool-bin libossp-uuid-dev libvncserver-dev freerdp2-dev libssh2-1-dev libtelnet-dev libwebsockets-dev libpulse-dev libvorbis-dev libwebp-dev libssl-dev libpango1.0-dev libswscale-dev libavcodec-dev libavutil-dev libavformat-dev

wget https://archive.apache.org/dist/guacamole/1.2.0/source/guacamole-server-1.2.0.tar.gz

tar -xf guacamole-server-1.2.0.tar.gz

cd guacamole-server-1.2.0/

./configure --with-init-dir=/etc/init.d

make -j2

sudo make install

sudo ldconfig

sudo systemctl daemon-reload
sudo systemctl enable guacd
sudo systemctl start guacd

#systemctl status guacd

# Install the tomcat server which will host the web front end.
sudo apt -y install tomcat9 tomcat9-admin tomcat9-common tomcat9-user

# Move back into the main directory
cd ..

# Donwload and install the guacamole web app.
wget https://downloads.apache.org/guacamole/1.2.0/binary/guacamole-1.2.0.war

sudo mv guacamole-1.2.0.war /var/lib/tomcat9/webapps/guacamole.war

sudo systemctl restart tomcat9 guacd

# Make the configuration files for guacamole
sudo mkdir /etc/guacamole/

sudo sh -c 'echo "# Hostname and port of guacamole proxy
guacd-hostname: localhost
guacd-port:     4822

# Auth provider class (authenticates user/pass combination, needed if using the provided login screen)
auth-provider: net.sourceforge.guacamole.net.basic.BasicFileAuthenticationProvider
basic-user-mapping: /etc/guacamole/user-mapping.xml
" > /etc/guacamole/guacamole.properties'

# Here we need to provide the user login details.  We'll need to make an
# md5 hash from the password we want to use.  I'm not sure yet how this 
# relates to the username we're running under.  We might need to make a 
# student account first and do the rest of this in there?

export PWMD=`echo -n $INSTANCE | openssl md5 | sed 's/^.* //'`

# Note that we need the -E on sudo so the PWMD variable
# is passed through to root's environment.
sudo -E sh -c 'echo "<user-mapping>

    <!-- Per-user authentication and config information -->
    <authorize
         username=\"student\"
         password=\"$PWMD\"
         encoding=\"md5\">

       <connection name=\"default\">
         <protocol>vnc</protocol>
         <param name=\"hostname\">localhost</param>
         <param name=\"port\">5901</param>
         <param name=\"password\">$INSTANCE</param>
       </connection>
    </authorize>
</user-mapping>
" > /etc/guacamole/user-mapping.xml'

# Now set up VNC
# The additional env variable should stop apt from prompting to set a
# display manager and will hopefully just pick a default (I don't really
# care what it picks)
sudo DEBIAN_FRONTEND=noninteractive apt -y install xfce4 xfce4-goodies firefox tigervnc-standalone-server

sudo systemctl restart tomcat9 guacd

sudo mkdir ~student/.vnc

sudo sh -c 'echo "
#!/bin/sh

xrdb /home/student/.Xresources
dbus-launch startxfce4 &

" > ~student/.vnc/xstartup'

# Set the VNC password to the instance ID
# The redirection we do here needs BASH rather than just SH
sudo -E bash -c "vncpasswd -f <<< $INSTANCE > ~student/.vnc/passwd"

# We need to make the passwd file only readable by student otherwise
# vnc won't accept it and will prompt us to change it when we start
# the server.
sudo chmod 600 ~student/.vnc/passwd

# We need to change the newly created vnc files to be owned by student
# (they're owned by root at the moment)
sudo chown -R student:student ~student/.vnc

# Reset the XFCE background
sudo cp images/xfce_background.png /usr/share/backgrounds/xfce/xfce-stripes.png

# Set up apache as a proxy server
sudo apt -y install apache2

# Enable the apache modules we need
sudo a2enmod proxy proxy_http headers proxy_wstunnel

# Create the config file.  We proxy everything to port 80
# except for the image on the login screen which we bypass
# This can then be retrieved from /var/www/html/images
# so we can substitute in our own image instead.

sudo sh -c 'echo "<VirtualHost *:80>
      ErrorLog ${APACHE_LOG_DIR}/guacamole_error.log
      CustomLog ${APACHE_LOG_DIR}/guacamole_access.log combined

      <Location />
          Require all granted
          ProxyPass http://localhost:8080/guacamole/ flushpackets=on
          ProxyPassReverse http://localhost:8080/guacamole/
      </Location>

      <Location /images/guac-tricolor.png>
           ProxyPass !
      </Location>

     <Location /websocket-tunnel>
         Require all granted
         ProxyPass ws://localhost:8080/guacamole/websocket-tunnel
         ProxyPassReverse ws://localhost:8080/guacamole/websocket-tunnel
     </Location>

     Header always unset X-Frame-Options
</VirtualHost>" > /etc/apache2/sites-available/guacamole.conf
'

# Enable the new virtual host
sudo a2ensite guacamole.conf

# Remove the default virtual host so guacamole is found first
sudo mv /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/zzz-default.conf

# Restart apache
sudo systemctl restart apache2

# Copy our logo file into the web root so we can use it
sudo mkdir /var/www/html/images/
sudo cp images/guacamole_logo.png /var/www/html/images/guac-tricolor.png

# Now we can start the VNC server
sudo su student -c 'cd /home/student; vncserver -depth 24 -geometry 1280x800'



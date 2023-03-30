#/bin/bash

# Because we have to link to the account we ultimately want to use we'll switch straight
# to that at the start rather than using the default ubuntu account

# Create the user we're going to use and make sure their home
# directory is also created since useradd doesn't do this by
# default

sudo useradd -m -G sudo -d /home/student -s /bin/bash student

# We now have the student account available to us.  We'll do some basic building in
# ubuntu but then switch over when we get to VNC stuff.

# Build guacamole from source since there isn't an ubuntu
# package we can use yet.
sudo apt update
sudo apt -y install build-essential cmake libcairo2-dev libjpeg-turbo8-dev libpng-dev libtool-bin libossp-uuid-dev libvncserver-dev freerdp2-dev libssh2-1-dev libtelnet-dev libwebsockets-dev libpulse-dev libvorbis-dev libwebp-dev libssl-dev libpango1.0-dev libswscale-dev libavcodec-dev libavutil-dev libavformat-dev

wget https://archive.apache.org/dist/guacamole/1.5.0/source/guacamole-server-1.5.0.tar.gz

tar -xf guacamole-server-1.5.0.tar.gz

cd guacamole-server-1.5.0/

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
wget https://archive.apache.org/dist/guacamole/1.5.0/binary/guacamole-1.5.0.war

sudo mv guacamole-1.5.0.war /var/lib/tomcat9/webapps/guacamole.war

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


# Now set up VNC
# The additional env variable should stop apt from prompting to set a
# display manager and will hopefully just pick a default (I don't really
# care what it picks)
sudo DEBIAN_FRONTEND=noninteractive apt -y install xfce4 xfce4-goodies firefox tigervnc-standalone-server

sudo systemctl restart tomcat9 guacd

sudo mkdir ~student/.vnc

sudo sh -c 'echo "
#!/bin/sh
startxfce4
" > ~student/.vnc/xstartup'


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

# Put the reboot script into /usr/local/bin
sudo cp scripts/student_reboot_reset /usr/local/bin/

# Add the launching of the script to the reboot cron
sudo sh -c 'echo "
@reboot root /usr/local/bin/student_reboot_reset
" > /etc/cron.d/reset_password'


# Run the script to set the password and start the vnc server
sudo /usr/local/bin/student_reboot_reset


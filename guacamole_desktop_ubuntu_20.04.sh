### THIS IS NOT FINISHED AND DOESN'T WORK YET ###

sudo apt update

#/bin/bash

# Because we have to link to the account we ultimately want to use we'll switch straight
# to that at the start rather than using the default ubuntu account

# Create the user we're going to use and make sure their home
# directory is also created since useradd doesn't do this by
# default

useradd -m -G sudo -d /home/student -s /bin/bash student

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
sudo apt -y install build-essential libcairo2-dev libjpeg-turbo8-dev libpng-dev libtool-bin libossp-uuid-dev libvncserver-dev freerdp2-dev libssh2-1-dev libtelnet-dev libwebsockets-dev libpulse-dev libvorbis-dev libwebp-dev libssl-dev libpango1.0-dev libswscale-dev libavcodec-dev libavutil-dev libavformat-dev

wget http://mirror.cc.columbia.edu/pub/software/apache/guacamole/1.2.0/source/guacamole-server-1.2.0.tar.gz

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

cd

# Donwload and install the guacamole web app.
wget https://downloads.apache.org/guacamole/1.2.0/binary/guacamole-1.2.0.war

sudo mv guacamole-1.2.0.war /var/lib/tomcat9/webapps/guacamole.war

sudo systemctl restart tomcat9 guacd

# Make the configuration files for guacamole
sudo mkdir /etc/guacamole/

echo "# Hostname and port of guacamole proxy
guacd-hostname: localhost
guacd-port:     4822

# Auth provider class (authenticates user/pass combination, needed if using the provided login screen)
auth-provider: net.sourceforge.guacamole.net.basic.BasicFileAuthenticationProvider
basic-user-mapping: /etc/guacamole/user-mapping.xml
" > /etc/guacamole/guacamole.properties

# Here we need to provide the user login details.  We'll need to make an
# md5 hash from the password we want to use.  I'm not sure yet how this 
# relates to the username we're running under.  We might need to make a 
# student account first and do the rest of this in there?

export PWMD=`echo -n $INSTANCE | openssl md5 | sed 's/^.* //'`
echo "<user-mapping>

    <!-- Per-user authentication and config information -->
BBB    <authorize
         username=\"student\"
         password=\"$PWMD\"
         encoding=\"md5\">

       <connection name=\"default\">
         <protocol>vnc</protocol>
         <param name=\"hostname\">localhost</param>
         <param name=\"port\">5901</param>
         <param name=\"password\">testtest</param>
       </connection>
    </authorize>
" > /etc/guacamole/user-mapping.xml


sudo systemctl restart tomcat9 guacd

# Now set up VNC
sudo apt -y install xfce4 xfce4-goodies firefox

sudo apt -y install tigervnc-standalone-server

sudo systemctl restart tomcat9 guacd

echo "
#!/bin/sh

xrdb $HOME/.Xresources
startxfce4 &

" > ~student/.vnc/xstartup


echo "
[Unit]
Description=a wrapper to launch an X server for VNC
After=syslog.target network.target

[Service]
Type=forking
User=username
Group=username
WorkingDirectory=/home/ubuntu

ExecStartPre=-/usr/bin/vncserver -kill :%i > /dev/null 2>&1
ExecStart=/usr/bin/vncserver -depth 24 -geometry 1280x800 -localhost :%i
ExecStop=/usr/bin/vncserver -kill :%i

[Install]
WantedBy=multi-user.target
" > /etc/systemd/system/vncserver@.service

vncserver -kill :1

sudo systemctl enable vncserver@1.service
sudo systemctl start vncserver@1.service

# This fails at this stage, but it's not clear to me why.  The stand alone
# VNC command works so I can't see why the version in the unit fails.  The
# only thing which is different is the depth and geometry settings. Also where
# the %i comes from


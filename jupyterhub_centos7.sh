# Install python
yum -y install python3

# Install Development Tools so we can compile packages
yum -y groupinstall "Development Tools"

# Create the user we're going to use and make sure their home
# directory is also created since useradd doesn't do this by
# default

useradd -m -d /home/student -s /bin/bash student

# Set their password since we don't want a hardcoded password.  To give some
# randomness we'll use the instance ID of the server as the initial password
# so the user can see that in their EC2 console.  The user should still change
# this once they've logged in for the first time.

# We use the AWS link-local HTTP API to retrieve the current instance ID.  This
# will only work on the actual AWS image.  This bit will obviously fail if you're
# not on AWS

yum -y install curl
sudo sh -c 'curl -s http://169.254.169.254/latest/meta-data/instance-id | passwd --stdin student'

# Install the notebook packages
pip3 install notebook

# Install the hub
pip3 install jupyterhub

# This needs npm to get configurable http proxy
curl -sL https://rpm.nodesource.com/setup_10.x | sudo bash -
yum install -y nodejs
npm install -g configurable-http-proxy

# Put some of the most common packages in place. It looks like
# seaborn already depends on all of the other relevant stuff so
# this covers pretty much everything on its own.
pip3 install seaborn

# Since we're on AWS we're going to end up using plain HTTP for our
# connections.  Jupyterhub will give us a warning on every login about
# this which we can't do anything about, so let's hide it
perl -i.bak -pe "s/<p id='insecure-login-warning' class='hidden'>/<p class='hidden'>/" login.html

# We can also swap out the logo so we can brand this with our logo
cp images/bioinformatics_logo_225x80.png /usr/local/share/jupyterhub/static/images/jupyterhub-80.png

# We need to configure apache to proxy the Jupyterhub server on port 8000 onto the
# main web server on port 80.  We can't set up SSL since we don't have a specific 
# domain name, and you can't use LetsEncrypt on the AWS IP range for obvious reasons.
yum -y install httpd
systemctl enable httpd

# Remove the config for the holding screen
rm /etc/httpd/conf.d/welcome.conf

# Allow apache network access in selinux so it can act as a proxy
setsebool -P httpd_can_network_connect on

# Write the config file we need 

echo "
<VirtualHost *:80>
  ProxyPreserveHost On
  ProxyRequests Off
  ProxyPass / http://127.0.0.1:8000/
  ProxyPassReverse / http://127.0.0.1:8000/
</VirtualHost>
" > /etc/httpd/conf.d/jupyterhub.conf

systemctl start httpd


# Start the actual server. We do this by creating a systemd 
# unit for it and then starting that.

echo "#!/bin/bash
export PATH=$PATH:/usr/local/bin/
jupyterhub > /var/log/jupyterhub 2>&1
" > /usr/local/sbin/start_jupyterhub.sh

chmod 755 /usr/local/sbin/start_jupyterhub.sh

echo "[Unit]
Description=Starts the jupyterhub service
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/sbin/start_jupyterhub.sh
TimeoutStartSec=0

[Install]
WantedBy=default.target
" > /etc/systemd/system/jupyterhub.service

# Now register and start the service
systemctl daemon-reload
systemctl enable jupyterhub
systemctl start jupyterhub



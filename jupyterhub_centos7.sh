# Install python
sudo yum -y install python3

# Install Development Tools so we can compile packages
sudo yum -y groupinstall "Development Tools"

# Create the user we're going to use and make sure their home
# directory is also created since useradd doesn't do this by
# default

sudo useradd -m -d /home/student -s /bin/bash student

# Set their password since we don't want a hardcoded password.  To give some
# randomness we'll use the instance ID of the server as the initial password
# so the user can see that in their EC2 console.  The user should still change
# this once they've logged in for the first time.

# We use the AWS link-local HTTP API to retrieve the current instance ID.  This
# will only work on the actual AWS image.  This bit will obviously fail if you're
# not on AWS

sudo yum -y install curl
sudo sh -c 'curl -s http://169.254.169.254/latest/meta-data/instance-id | passwd --stdin student'

# Install the notebook packages
sudo pip3 install notebook

# Install the hub
sudo pip3 install jupyterhub

# This needs npm to get configurable http proxy
curl -sL https://rpm.nodesource.com/setup_10.x | sudo bash -
sudo yum install -y nodejs
sudo npm install -g configurable-http-proxy

# Put some of the most common packages in place. It looks like
# seaborn already depends on all of the other relevant stuff so
# this covers pretty much everything on its own.
sudo pip3 install seaborn
sudo pip3 install jupyterlab

# Since we're on AWS we're going to end up using plain HTTP for our
# connections.  Jupyterhub will give us a warning on every login about
# this which we can't do anything about, so let's hide it
sudo perl -i.bak -pe "s/<p id='insecure-login-warning' class='hidden'>/<p class='hidden'>/" /usr/local/share/jupyterhub/templates/login.html

# We can also swap out the logo so we can brand this with our logo
sudo cp images/bioinformatics_logo_225x80.png /usr/local/share/jupyterhub/static/images/jupyterhub-80.png

# Start the actual server. We do this by creating a systemd 
# unit for it and then starting that.

sudo sh -e '
echo "#!/bin/bash
export PATH=$PATH:/usr/local/bin/
jupyterhub --port=80 > /var/log/jupyterhub 2>&1
" > /usr/local/sbin/start_jupyterhub.sh'

sudo chmod 755 /usr/local/sbin/start_jupyterhub.sh

sudo sh -e '
echo "[Unit]
Description=Starts the jupyterhub service
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/sbin/start_jupyterhub.sh
TimeoutStartSec=0

[Install]
WantedBy=default.target
" > /etc/systemd/system/jupyterhub.service'

# Now register and start the service
sudo systemctl daemon-reload
sudo systemctl enable jupyterhub
sudo systemctl start jupyterhub



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


# Start the actual server (need to find a better way to do this)
# /usr/local/bin isn't in the default path so we need to add it at
# run time.
sudo sh -c "export PATH=$PATH:/usr/local/bin/;jupyterhub"



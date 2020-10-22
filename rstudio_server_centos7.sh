# R is in EPEL so we need to set that repository up first
yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

# Now we can install R.  We won't use the version in CentOS or EPEL
# since that gets out of date.  Instead we'll use the version which 
# rstudio compile which will be more up to date
#
# Note that we will need to update this if we want to move to a newer version of
# R
export R_VERSION=4.0.3

yum -y install https://cdn.rstudio.com/r/centos-7/pkgs/R-${R_VERSION}-1-1.x86_64.rpm

# We also need to add this to the PATH since it gets installed into /opt by default.
# We'll take the shortcut of just linking it to /usr/local/bin.  If we don't do this
# then rstudio-server won't start

ln -s /opt/R/${R_VERSION}/bin/R /usr/local/bin/

# To compile R packages we need the development tools
yum -y groupinstall "Development Tools"

# Install the RStudio Server RPM from the Rstudio site
# It would be good if there was a shortcut to the latest
# version, otherwise we'll have to keep updating this, or
# maybe do something clever where we parse it from the 
# download page HTML

yum -y install https://download2.rstudio.org/server/centos6/x86_64/rstudio-server-rhel-1.3.1093-x86_64.rpm

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

# We need to configure apache to proxy the RStudio Server on port 8787 onto the
# main web server on port 80.  We can't set up SSL since we don't have a specific 
# domain name, and you can't use LetsEncrypt on the AWS IP range for obvious reasons.

# We should install some basic R packages which everything will need.


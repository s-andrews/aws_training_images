# This script should be able to be run as a conventional alma user from their
# home directory (manual installation), or as root from the top of the filesystem
# (templated installs).

# R is in EPEL so we need to set that repository up first
sudo dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm

# We need to enable the CRB repository to ensure EPEL packages work properly
sudo /usr/bin/crb enable

# Now we can install R.  We won't use the version in Alma or EPEL
# since that gets out of date.  Instead we'll use the version which 
# rstudio compile which will be more up to date
#
# Note that we will need to update this if we want to move to a newer version of
# R
export R_VERSION=4.4.1

sudo -E dnf -y install https://cdn.rstudio.com/r/centos-8/pkgs/R-${R_VERSION}-1-1.x86_64.rpm

# We also need to add this to the PATH since it gets installed into /opt by default.
# We'll take the shortcut of just linking it to /usr/local/bin.  If we don't do this
# then rstudio-server won't start

sudo -E ln -s /opt/R/${R_VERSION}/bin/R /usr/local/bin/
sudo -E ln -s /opt/R/${R_VERSION}/bin/Rscript /usr/local/bin/

# To compile R packages we need the development tools
sudo dnf -y groupinstall "Development Tools"

# Install the RStudio Server RPM from the Rstudio site
# It would be good if there was a shortcut to the latest
# version, otherwise we'll have to keep updating this, or
# maybe do something clever where we parse it from the 
# download page HTML

sudo dnf -y install https://download2.rstudio.org/server/rhel8/x86_64/rstudio-server-rhel-2024.04.2-764-x86_64.rpm

# Change the logo on the login page to ours
sudo cp images/bioinformatics_logo_78x28.png /usr/lib/rstudio-server/www/images/rstudio.png

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

sudo dnf -y install curl
sudo sh -c 'TOKEN=`curl -s -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"` && curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/dynamic/instance-identity/document/ | grep instanceId | cut -c 19-37 | passwd --stdin student'

# Put the reboot script into /usr/local/bin
sudo cp scripts/student_password_reset /usr/local/bin/

# Add the launching of the script to the reboot cron
sudo sh -c 'echo "
@reboot root /usr/local/bin/student_password_reset
" > /etc/cron.d/reset_password'

# We need to configure apache to proxy the RStudio Server on port 8787 onto the
# main web server on port 80.  We can't set up SSL since we don't have a specific 
# domain name, and you can't use LetsEncrypt on the AWS IP range for obvious reasons.
sudo dnf -y install httpd
sudo systemctl enable httpd

# Remove the config for the holding screen
sudo rm -f /etc/httpd/conf.d/welcome.conf

# I give up trying to make selinux work so we'll just kill it
# This was needed to let apache act as a proxy
sudo setsebool -P httpd_can_network_connect on
sudo setenforce permissive

# We also write this to the config so it survives a reboot
sudo sh -c 'echo "
# This file controls the state of SELinux on the system.
# SELINUX= can take one of these three values:
#     enforcing - SELinux security policy is enforced.
#     permissive - SELinux prints warnings instead of enforcing.
#     disabled - No SELinux policy is loaded.
SELINUX=permissive
# SELINUXTYPE= can take one of these three values:
#     targeted - Targeted processes are protected,
#     minimum - Modification of targeted policy. Only selected processes are protected.
#     mls - Multi Level Security protection.
SELINUXTYPE=targeted
" > /etc/selinux/config'

# Write the config file we need 

sudo sh -c 'echo "
<VirtualHost *:80>
  ProxyPreserveHost On
  ProxyRequests Off
  ProxyPass / http://127.0.0.1:8787/
  ProxyPassReverse / http://127.0.0.1:8787/
</VirtualHost>
" > /etc/httpd/conf.d/rstudio.conf'

sudo systemctl start httpd

# We should install some basic R packages which everything will need. This also means
# installing some OS packages which are needed to build them.
sudo dnf -y install libxml2-devel openssl-devel fontconfig-devel harfbuzz-devel fribidi-devel  freetype-devel libpng-devel libtiff-devel libjpeg-turbo-devel
sudo /usr/local/bin/Rscript -e "install.packages('tidyverse', repos='https://cloud.r-project.org')"

# For downloads to work we need to install additional certificates
sudo yum -y install wget ca-certificates

# There is a bug in R on CentOS where running Sys.timezone() causes an SELINUX AVC error
# and takes ages to time out.  Since this is called when loading tidyverse we get a very 
# long pause and an error (although it does eventually work).  We can work around this
# by setting the TZ value in ~/.Renviron so that it doesn't try to detect it.

sudo sh -c 'echo "
TZ="UTC"
" >> /home/student/.Renviron'

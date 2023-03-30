#!/bin/bash

# Install the latest version of firefox.
# We can't use the one in the snap store because there's a bug which  means
# that confined snap applications don't work over VNC.
#
# https://bugs.launchpad.net/ubuntu/+source/snapd/+bug/1951491

sudo wget -O /opt/firefox.tar.bz "https://download.mozilla.org/?product=firefox-latest&os=linux64&lang=en-US"
sudo tar -C /opt/ -xjf /opt/firefox.tar.bz
sudo ln -s /opt/firefox/firefox /usr/local/bin/


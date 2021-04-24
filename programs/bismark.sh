#!/bin/bash
sudo wget -O /opt/bismark.tar.gz https://github.com/FelixKrueger/Bismark/archive/0.23.0.tar.gz
sudo tar -C /opt/ -xzf /opt/bismark.tar.gz
sudo mv /opt/Bismark-0.23.0 /opt/bismark

# There are too many bismark programs to link them all individually
# so we just put the whole folder on the path

sudo sh -c 'echo "export PATH=\$PATH:/opt/bismark
" > /etc/profile.d/bismark.sh'


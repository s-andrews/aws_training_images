#!/bin/bash
sudo apt -y install python3-pip
sudo pip3 install cutadapt
sudo wget -O /opt/trim_galore.tar.gz https://github.com/FelixKrueger/TrimGalore/archive/0.6.6.tar.gz
sudo tar -C /opt/ -xzf /opt/trim_galore.tar.gz
sudo mv /opt/TrimGalore-0.6.6 /opt/trim_galore
sudo ln -s /opt/trim_galore/trim_galore /usr/local/bin/

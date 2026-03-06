#!/bin/bash
sudo apt -y install python3-pip python3.12-venv
cd /opt
sudo python3 -m venv macs2
sudo bash -c "source macs2/bin/activate; pip3 install MACS2"
sudo ln -s /opt/macs2/bin/macs2 /usr/local/bin/

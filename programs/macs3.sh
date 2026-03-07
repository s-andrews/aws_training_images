#!/bin/bash
sudo apt -y install python3-pip python3.12-venv
cd /opt
sudo python3 -m venv macs3
sudo bash -c "source macs3/bin/activate; pip3 install MACS3"
sudo ln -s /opt/macs3/bin/macs3 /usr/local/bin/

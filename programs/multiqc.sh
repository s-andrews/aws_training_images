#!/bin/bash
sudo apt -y install python3-pip python3.12-venv
cd /opt
sudo python3 -m venv multiqc
sudo bash -c "source multiqc/bin/activate; pip3 install multiqc"
sudo ln -s /opt/multiqc/bin/multiqc /usr/local/bin/

#!/bin/bash
sudo apt -y install openjdk-21-jdk
sudo wget -O /opt/fastqc.zip https://github.com/s-andrews/FastQC/releases/download/v0.13.0/fastqc_v0.13.0.zip 
sudo unzip -d /opt/ /opt/fastqc.zip
sudo chmod 755 /opt/FastQC/fastqc
sudo ln -s /opt/FastQC/fastqc /usr/local/bin

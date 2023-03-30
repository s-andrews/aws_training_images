#!/bin/bash
sudo apt -y install openjdk-11-jdk
sudo wget -O /opt/fastqc.zip https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.12.1.zip 
sudo unzip -d /opt/ /opt/fastqc.zip
sudo chmod 755 /opt/FastQC/fastqc
sudo ln -s /opt/FastQC/fastqc /usr/local/bin

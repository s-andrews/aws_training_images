#!/bin/bash

# Start from the guacamole desktop
./guacamole_desktop_ubuntu_20.04.sh

# Install demo programs
sudo apt -y install figlet
sudo apt -y install xcowsay

# Install FastQC
sudo wget -O /opt/fastqc.zip http://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.9.zip 
sudo unzip -d /opt/ /opt/fastqc.zip
sudo chmod 755 /opt/FastQC/fastqc
sudo ln -s /opt/FastQC/fastqc /usr/local/bin

# Install MultiQC
sudo apt -y install python3-pip
sudo pip3 install multiqc

# Install course data
sudo wget -O ~student/unix_intro_data.tar.gz http://www.bioinformatics.babraham.ac.uk/training/Introduction%20to%20Unix/unix_intro_data.tar.gz
sudo tar -C ~student/ -xf ~student/unix_intro_data.tar.gz
sudo chown -R student:student ~student/FastQ_Data
sudo chown -R student:student ~student/seqmonk_genomes
sudo rm -f ~student/unix_intro_data.tar.gz


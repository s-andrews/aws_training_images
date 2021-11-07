#!/bin/bash

# Start from the guacamole desktop
./guacamole_desktop_ubuntu_20.04.sh

# Install standard programs
./programs/fastqc.sh
./programs/multiqc.sh

# Install demo programs
sudo apt -y install figlet
sudo apt -y install xcowsay

# Install course data
sudo wget -O ~student/unix_intro_data.tar.gz http://www.bioinformatics.babraham.ac.uk/training/Introduction%20to%20Unix/unix_intro_data.tar.gz
sudo tar -C ~student/ -xf ~student/unix_intro_data.tar.gz
sudo chown -R student:student ~student/FastQ_Data
sudo chown -R student:student ~student/seqmonk_genomes
sudo rm -f ~student/unix_intro_data.tar.gz

# Add the data for the QC course too as we often do them together
sudo wget -O ~student/Sequencing_Quality_Control_Data.zip http://www.bioinformatics.babraham.ac.uk/training/Sequence_QC_Course/Sequencing_Quality_Control_Data.zip
sudo unzip -d ~student/ ~student/Sequencing_Quality_Control_Data.zip
sudo chown -R student:student ~student/Sequencing_Quality_Control_Data
sudo rm -f ~student/Sequencing_Quality_Control_Data.zip


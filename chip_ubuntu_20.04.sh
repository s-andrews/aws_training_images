#!/bin/bash

# Start from the guacamole desktop
./guacamole_desktop_ubuntu_20.04.sh

# Install programs
./programs/fastqc.sh
./programs/bowtie2.sh
./programs/multiqc.sh
./programs/macs2.sh
./programs/trim_galore.sh
./programs/samtools.sh
./programs/seqmonk.sh


# Remove xarchiver since if people double clicked on a big
# gzipped file it would hang the server.

sudo apt -y remove xarchiver

# Install course data
sudo wget -O ~student/worm_data.tar.gz http://www.bioinformatics.babraham.ac.uk/training/ChIP-Seq_Analysis/Worm_ChIP_Mapping.tar.gz
sudo tar -C ~student/ -xf ~student/worm_data.tar.gz
sudo chown -R student:student ~student/Worm_ChIP_Mapping
sudo rm -f ~student/worm_data.tar.gz

sudo wget -O ~student/desktop_data.zip http://www.bioinformatics.babraham.ac.uk/training/ChIP-Seq_Analysis/Desktop_ChIP_Data.zip
sudo unzip -d ~student/ ~student/desktop_data.zip
sudo chown -R student:student ~student/Desktop_ChIP_Data
sudo rm -f ~student/desktop_data.zip

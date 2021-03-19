#!/bin/bash

# Start from the guacamole desktop
./guacamole_desktop_ubuntu_20.04.sh

# Install programs
./programs/r.sh
./programs/fastqc.sh
./programs/hisat2.sh
./programs/multiqc.sh
./programs/trim_galore.sh
./programs/samtools.sh
./programs/seqmonk.sh

# Remove xarchiver since if people double clicked on a big
# gzipped file it would hang the server.

sudo apt -y remove xarchiver

# Install course data
sudo wget --quiet -O ~student/yeast_data.tar.gz http://www.bioinformatics.babraham.ac.uk/training/RNASeq_Course/yeast_data.tar.gz
sudo tar -C ~student/ -xf ~student/yeast_data.tar.gz
sudo chown -R student:student ~student/Yeast_data_for_mapping
sudo rm -f ~student/yeast_data.tar.gz

sudo wget --quiet -O ~student/mouse_mapped_data.zip http://www.bioinformatics.babraham.ac.uk/training/RNASeq_Course/mouse_mapped_data.zip
sudo unzip -d ~student/ ~student/mouse_mapped_data.zip
sudo chown -R student:student ~student/mouse_mapped_data
sudo rm -f ~student/mouse_mapped_data.zip

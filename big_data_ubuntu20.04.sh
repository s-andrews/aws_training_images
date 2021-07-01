#!/bin/bash

# Start from the guacamole desktop
./guacamole_desktop_ubuntu_20.04.sh

# Install programs
./programs/r.sh
./programs/fastqc.sh
./programs/seqmonk.sh
./programs/igv.sh
./programs/fcsalyzer.sh


# Install course data
sudo wget --quiet -O ~student/bigdata.tar.gz http://www.bioinformatics.babraham.ac.uk/training/bigdata/bigdata.tar.gz
sudo tar -C ~student/ -xf ~student/bigdata.tar.gz
sudo chown -R student:student ~student/Big_Data
sudo rm -f ~student/bigdata.tar.gz

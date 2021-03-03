#!/bin/bash

# Start from the guacamole desktop
./guacamole_desktop_ubuntu_20.04.sh

# Install programs
./programs/seqmonk.sh

# Install course data

sudo wget --quiet -O ~student/seqmonk.zip https://www.bioinformatics.babraham.ac.uk/training/SeqMonk_Introduction/SeqMonk_Course_Data.zip
sudo unzip -d ~student/ ~student/seqmonk.zip
sudo chown -R student:student ~student/SeqMonk_Course_Data
sudo rm -f ~student/seqmonk.zip

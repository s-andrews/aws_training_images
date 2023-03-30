#!/bin/bash

# Start from the guacamole desktop
./guacamole_desktop_ubuntu.sh

# Install programs
./programs/r.sh
./programs/fastqc.sh
./programs/bowtie2.sh
./programs/multiqc.sh
./programs/trim_galore.sh
./programs/bismark.sh
./programs/samtools.sh
./programs/seqmonk.sh

# Install course data
sudo wget -O ~student/meth_data.tar http://www.bioinformatics.babraham.ac.uk/training/Methylation_Course/Meth_Course_Data_Small.tar
sudo tar -C ~student/ -xf ~student/meth_data.tar
sudo chown -R student:student ~student/Meth_Course_Data
sudo rm -f ~student/meth_data.tar


#!/bin/bash

# Start from the guacamole desktop
./guacamole_desktop_ubuntu_20.04.sh

# Install programs
./programs/r.sh
./programs/fastqc.sh
./programs/seqmonk.sh
./programs/igv.sh
./programs/fcsalyzer.sh
./programs/multiqc.sh

sudo apt -y install figlet
sudo apt -y install xcowsay
sudo apt -y install vlc

# Install RStudio
sudo apt -y install gdebi-core
sudo wget https://download1.rstudio.org/desktop/bionic/amd64/rstudio-1.4.1717-amd64.deb
sudo gdebi -n rstudio-1.4.1717-amd64.deb

# Install Thonny
sudo apt -y install thonny
sudo pip install requests
sudo pip install biopython

# Install course data
sudo wget --quiet -O ~student/bigdata.tar.gz http://www.bioinformatics.babraham.ac.uk/training/bigdata/bigdata.tar.gz
sudo tar -C ~student/ -xf ~student/bigdata.tar.gz
sudo chown -R student:student ~student/Big_Data
sudo rm -f ~student/bigdata.tar.gz

# Install unix course data
sudo wget -O ~student/unix_intro_data.tar.gz http://www.bioinformatics.babraham.ac.uk/training/Introduction%20to%20Unix/unix_intro_data.tar.gz
sudo tar -C ~student/ -xf ~student/unix_intro_data.tar.gz
sudo chown -R student:student ~student/FastQ_Data
sudo chown -R student:student ~student/seqmonk_genomes
sudo rm -f ~student/unix_intro_data.tar.gz

# Install tidyverse and rstatix
sudo Rscript -e "install.packages('tidyverse', repos='http://cloud.r-project.org')"
sudo Rscript -e "install.packages('rstatix', repos='http://cloud.r-project.org')"

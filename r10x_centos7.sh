#!/bin/bash

# This image can be used for any or all of the following courses
# 
# 10x scRNA course


# Start from the rstudio image
./rstudio_server_centos7.sh

# Install the packages we need

# Needed for the png package
sudo yum -y install libpng-devel
# Needed for hdf5r
sudo yum -y install hdf5-devel

sudo /usr/local/bin/Rscript -e "install.packages('Seurat', repos='https://cloud.r-project.org')"
sudo /usr/local/bin/Rscript -e "install.packages('hdf5r', repos='https://cloud.r-project.org')"
sudo /usr/local/bin/Rscript -e "install.packages('sleepwalk', repos='https://cloud.r-project.org')"
sudo /usr/local/bin/Rscript -e "install.packages('SCINA', repos='https://cloud.r-project.org')"


# Install intro course data
sudo yum -y install wget
sudo wget -O ~student/10x.zip https://www.bioinformatics.babraham.ac.uk/training/10XRNASeq/10XCourse%20Data.zip
sudo unzip -d ~student/ ~student/10x.zip
sudo chown -R student:student ~student/10XCourse\ Data
sudo rm -f ~student/10x.zip




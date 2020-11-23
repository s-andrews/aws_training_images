#!/bin/bash

# This image can be used for any or all of the following courses
# 
# 10x scRNA course


# Start from the rstudio image
./rstudio_server_centos7.sh

# Install the packages we need
sudo /usr/local/bin/Rscript -e "install.packages('Seurat', repos='https://cloud.r-project.org')"
sudo /usr/local/bin/Rscript -e "install.packages('sleepwalk', repos='https://cloud.r-project.org')"
sudo /usr/local/bin/Rscript -e "install.packages('SCINA', repos='https://cloud.r-project.org')"


# Install intro course data
sudo yum -y install wget
sudo wget -O ~student/10x.zip http://www.bioinformatics.babraham.ac.uk/training/10XRNASeq/10XCourse%20Data.zip
sudo unzip -d ~student/ ~student/10x.zip
sudo mv "~student/10XCourse Data/Seurat" ~student/Seurat
sudo chown -R student:student ~student/Seurat
sudo rm -f ~student/10x.zip
sudo rm -f "~student/10XCourse Data"





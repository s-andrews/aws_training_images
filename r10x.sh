#!/bin/bash

# This image can be used for any or all of the following courses
# 
# 10x scRNA course


# Start from the rstudio image
./rstudio_server_base.sh

# Install the packages we need

# Needed for the png package
sudo dnf -y install libpng-devel
# Needed for hdf5r
sudo dnf -y install hdf5-devel
# Needed for seurat
sudo dnf -y install geos-devel


# The version of the hdf5 library on centos7 means we can't install anything newer than 1.0.0 in this package
sudo /usr/local/bin/Rscript -e "install.packages('hdf5r', repos='https://cloud.r-project.org')"

# We shouldn't need to do this but seurat seems to fail when shiny isn't already installed
# so we'll manually add that first.
sudo /usr/local/bin/Rscript -e "install.packages('shiny', repos='https://cloud.r-project.org')"
sudo /usr/local/bin/Rscript -e "install.packages('Seurat', repos='https://cloud.r-project.org')"
sudo /usr/local/bin/Rscript -e "install.packages('sleepwalk', repos='https://cloud.r-project.org')"
sudo /usr/local/bin/Rscript -e "install.packages('SCINA', repos='https://cloud.r-project.org')"


# Install intro course data
sudo yum -y install wget
sudo wget -O ~student/10x.zip https://www.bioinformatics.babraham.ac.uk/training/10XRNASeq/10XCourse%20Data.zip
sudo unzip -d ~student/ ~student/10x.zip
sudo chown -R student:student ~student/10XCourse\ Data
sudo rm -f ~student/10x.zip




#!/bin/bash

# This image can be used for any or all of the following courses
# 
# proteomics course


# Start from the rstudio image
./rstudio_server_base.sh

# Install the packages we need

# Needed for the png package
sudo dnf -y install libpng-devel
# Needed for hdf5r
sudo dnf -y install hdf5-devel
# Needed for seurat
sudo dnf -y install geos-devel
# Needed for Azimuth
sudo dnf -y install gsl-devel
# Needed for one of the MSstats dependencies
sudo dnf -y install cmake

# We shouldn't need to do this but it seems to fail when shiny isn't already installed
# so we'll manually add that first.
sudo /usr/local/bin/Rscript -e "install.packages('shiny', repos='https://cloud.r-project.org')"

sudo /usr/local/bin/Rscript -e "install.packages('BiocManager', repos='https://cloud.r-project.org')"

sudo /usr/local/bin/Rscript -e "BiocManager::install('MSstatsShiny')"


# Install intro course data
sudo yum -y install wget
sudo wget -O ~student/proteomics.zip https://www.bioinformatics.babraham.ac.uk/training/proteomics/Proteomics_Course_Data.zip
sudo unzip -d ~student/ ~student/proteomics.zip
sudo chown -R student:student ~student/Proteomics_Course_data
sudo rm -f ~student/proteomics.zip




#!/bin/bash

# This image can be used for any or all of the following courses
# 
# 10x scRNA course


# Start from the rstudio image
#./rstudio_server_base.sh

# Install the packages we need

# Needed for the png package
sudo dnf -y install libpng-devel
# Needed for hdf5r
sudo dnf -y install hdf5-devel
# Needed for seurat
sudo dnf -y install geos-devel
# Hdf5 is needed to read cellranger files
sudo /usr/local/bin/Rscript -e "install.packages('hdf5r', repos='https://cloud.r-project.org')"

# We shouldn't need to do this but seurat seems to fail when shiny isn't already installed
# so we'll manually add that first.
sudo /usr/local/bin/Rscript -e "install.packages('shiny', repos='https://cloud.r-project.org')"
sudo /usr/local/bin/Rscript -e "install.packages('Seurat', repos='https://cloud.r-project.org')"


# Some extras for bits of seurat
sudo /usr/local/bin/Rscript -e "install.packages('Hmisc', repos='https://cloud.r-project.org')"
sudo /usr/local/bin/Rscript -e "install.packages('remotes', repos='https://cloud.r-project.org')"
sudo /usr/local/bin/Rscript -e "remotes::install_github('immunogenomics/presto')"

# We want loupeR
sudo /usr/local/bin/Rscript -e "remotes::install_github('10xGenomics/loupeR')"

# We also need to run setup, but we can't do this non-interactively, annoyingly so we'll need to do that manually later
#sudo /usr/local/bin/Rscript -e "loupeR::setup()')"


# We want Azimuth
sudo /usr/local/bin/Rscript -e "remotes::install_github('satijalab/seurat-data', ref='seurat5')"
sudo /usr/local/bin/Rscript -e "remotes::install_github('satijalab/azimuth', ref='seurat5')"

# Install intro course data
sudo yum -y install wget
sudo wget -O ~student/10x.zip https://www.bioinformatics.babraham.ac.uk/training/10XRNASeq/10XCourse%20Data.zip
sudo unzip -d ~student/ ~student/10x.zip
sudo chown -R student:student ~student/10XCourse\ Data
sudo rm -f ~student/10x.zip




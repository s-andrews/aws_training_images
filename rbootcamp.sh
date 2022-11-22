#!/bin/bash

# This image can be used for any or all of the following courses
# 
# Introduction to R (with Tidyverse)
# Advanced R (with Tidyverse)
# GGplot


# Start from the rstudio image
./rstudio_server_base.sh

# Install some additional needed packages

# Needed for devtools
sudo dnf -y install libgit2-devel

sudo /usr/local/bin/Rscript -e "install.packages('devtools', repos='https://cloud.r-project.org')"
sudo /usr/local/bin/Rscript -e "install.packages('roxygen2', repos='https://cloud.r-project.org')"
sudo /usr/local/bin/Rscript -e "install.packages('testthat', repos='https://cloud.r-project.org')"
sudo /usr/local/bin/Rscript -e "install.packages('knitr', repos='https://cloud.r-project.org')"

# Install intro course data
sudo wget -O ~student/rintro.zip https://www.bioinformatics.babraham.ac.uk/training/Introduction_to_R_tidyverse/R_tidyverse_intro_data.zip
sudo unzip -d ~student/ ~student/rintro.zip
sudo chown -R student:student ~student/R_tidyverse_intro_data
sudo rm -f ~student/rintro.zip

# Install advanced course data
sudo wget -O ~student/radvanced.zip https://www.bioinformatics.babraham.ac.uk/training/Advanced_R_Tidyverse/Advanced_R_Data.zip
sudo unzip -d ~student/ ~student/radvanced.zip
sudo chown -R student:student ~student/Advanced_R_Data
sudo rm -f ~student/radvanced.zip

# Install ggplot course data
sudo wget -O ~student/ggplot.zip https://www.bioinformatics.babraham.ac.uk/training/ggplot_course/ggplot_data_files.zip
sudo unzip -d ~student/ ~student/ggplot.zip
sudo chown -R student:student ~student/ggplot_data_files
sudo rm -f ~student/ggplot.zip


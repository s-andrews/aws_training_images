#!/bin/bash

# This image is used for the gene lists course

# Start from the rstudio image
./rstudio_server_base.sh

# Install some additional needed packages

sudo /usr/local/bin/Rscript -e "install.packages('BiocManager', repos='https://cloud.r-project.org')"
sudo /usr/local/bin/Rscript -e "BiocManager::install('clusterProfiler')"
sudo /usr/local/bin/Rscript -e "BiocManager::install('org.Mm.eg.db')"
sudo /usr/local/bin/Rscript -e "BiocManager::install('enrichplot')"
sudo /usr/local/bin/Rscript -e "install.packages('plotly', repos='https://cloud.r-project.org')"
sudo /usr/local/bin/Rscript -e "install.packages('ggupset', repos='https://cloud.r-project.org')"



# Download the course data
sudo wget -O ~student/fagl.zip https://www.bioinformatics.babraham.ac.uk/training/Extracting_Biological_Information_Course/Gene_Set_Analysis_Data.zip
sudo unzip -d ~student/ ~student/fagl.zip
sudo chown -R student:student ~student/Gene_Set_Analysis_Data
sudo rm -f ~student/fagl.zip

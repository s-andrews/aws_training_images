#!/bin/bash

# This image is for the introduction to machine learning course


# Start from the rstudio image
./rstudio_server_base.sh

# Install some additional needed packages
sudo /usr/local/bin/Rscript -e "install.packages('tidymodels', repos='https://cloud.r-project.org')"
sudo /usr/local/bin/Rscript -e "install.packages('ranger', repos='https://cloud.r-project.org')"
sudo /usr/local/bin/Rscript -e "install.packages('kknn', repos='https://cloud.r-project.org')"
sudo /usr/local/bin/Rscript -e "install.packages('brulee', repos='https://cloud.r-project.org')"
sudo /usr/local/bin/Rscript -e "torch::install_torch()"

# Install intro course data
sudo wget -O ~student/mldata.zip http://www.bioinformatics.babraham.ac.uk/training/MachineLearning/MachineLearningData.zip
sudo unzip -d ~student/ ~student/mldata.zip
sudo chown -R student:student ~student/MachineLearningData
sudo rm -f ~student/mldata.zip


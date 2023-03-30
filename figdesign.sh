#!/bin/bash

# Start from the guacamole desktop
./guacamole_desktop_ubuntu.sh

# Install evince to view PDFs
sudo apt -y install evince

# Install Inkscape
sudo apt -y install inkscape

# Install course data
sudo wget -O ~student/figure_data.zip http://www.bioinformatics.babraham.ac.uk/training/Figure_Design_Course/Figure%20Design%20Course%20Data.zip
sudo unzip -d ~student/ ~student/figure_data.zip
sudo chown -R student:student ~student/Figure\ Design\ Course\ Data
sudo rm -f ~student/figure_data.zip

# Install the exercise PDF
sudo wget -O ~student/data_representation_exericse.pdf https://www.bioinformatics.babraham.ac.uk/training/Figure_Design_Course/data_representation_exercise.pdf
sudo chown student:student ~student/data_representation_exericse.pdf

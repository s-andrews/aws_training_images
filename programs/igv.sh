#!/bin/bash

sudo wget -O /opt/igv.zip https://data.broadinstitute.org/igv/projects/downloads/2.19/IGV_Linux_2.19.7_WithJava.zip
sudo unzip -d /opt/ /opt/igv.zip
sudo ln -s /opt/IGV_Linux_2.19.7/igv.sh /usr/local/bin/igv

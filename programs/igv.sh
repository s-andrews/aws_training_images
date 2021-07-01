#!/bin/bash

sudo wget -O /opt/igv.zip https://data.broadinstitute.org/igv/projects/downloads/2.10/IGV_Linux_2.10.0_WithJava.zip
sudo unzip -d /opt/ /opt/igv.zip
sudo ln -s /opt/IGV_Linux_2.10.0/igv.sh /usr/local/bin/igv

#!/bin/bash
export TIMESTAMP=$(date +%s)
sudo wget -O /opt/bowtie2.zip https://sourceforge.net/projects/bowtie-bio/files/bowtie2/2.4.2/bowtie2-2.4.2-linux-x86_64.zip/download?ts=$TIMESTAMP\&use_mirror=autoselect
sudo unzip -d /opt/ /opt/bowtie2.zip
sudo mv /opt/bowtie2-2.4.2-linux-x86_64 /opt/bowtie2
sudo ln -s /opt/bowtie2/bowtie2 /usr/local/bin/
sudo ln -s /opt/bowtie2/bowtie2-build /usr/local/bin/
sudo rm /opt/bowtie2.zip

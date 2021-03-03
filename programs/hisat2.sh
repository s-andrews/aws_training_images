#!/bin/bash
sudo apt -y install python
sudo wget -O /opt/hisat2.zip https://cloud.biohpc.swmed.edu/index.php/s/oTtGWbWjaxsQ2Ho/download
sudo unzip -d /opt/ /opt/hisat2.zip
sudo mv /opt/hisat2-2.2.1 /opt/hisat2
sudo ln -s /opt/hisat2/hisat2 /usr/local/bin/
sudo ln -s /opt/hisat2/hisat2-build /usr/local/bin/
sudo ln -s /opt/hisat2/extract_splice_sites.py /usr/local/bin/
sudo ln -s /opt/hisat2/hisat2_extract_splice_sites.py /usr/local/bin/

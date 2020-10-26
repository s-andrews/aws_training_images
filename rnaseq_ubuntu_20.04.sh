#!/bin/bash

# Start from the guacamole desktop
./guacamole_desktop_ubuntu_20.04.sh

# Install FastQC
sudo wget -O /opt/fastqc.zip http://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.9.zip 
sudo unzip -d /opt/ /opt/fastqc.zip
sudo chmod 755 /opt/FastQC/fastqc
sudo ln -s /opt/FastQC/fastqc /usr/local/bin

# Install hisat2
sudo apt -y install python
sudo wget -O /opt/hisat2.zip https://cloud.biohpc.swmed.edu/index.php/s/4pMgDq4oAF9QCfA/download
sudo unzip -d /opt/ /opt/hisat2.zip
sudo mv /opt/hisat2-2.2.1 /opt/hisat2
sudo ln -s /opt/hisat2/hisat2 /usr/local/bin/
sudo ln -s /opt/hisat2/hisat2-build /usr/local/bin/
sudo ln -s /opt/hisat2/extract_splice_sites.py /usr/local/bin/

# Install MultiQC
sudo apt -y install python3-pip
sudo pip3 install multiqc

# Install Trim Galore
sudo pip3 install cutadapt
sudo wget -O /opt/trim_galore.tar.gz https://github.com/FelixKrueger/TrimGalore/archive/0.6.6.tar.gz
sudo tar -C /opt/ -xzf /opt/trim_galore.tar.gz
sudo mv /opt/TrimGalore-0.6.6 /opt/trim_galore
sudo ln -s /opt/trim_galore/trim_galore /usr/local/bin/

# Install samtools
sudo apt -y install samtools

# Install R
sudo sh -c 'echo "deb https://cloud.r-project.org/bin/linux/ubuntu focal-cran40/" >> /etc/apt/sources.list'
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
sudo apt update
sudo apt -y install r-base

# Install SeqMonk
sudo wget -O /opt/seqmonk.tar.gz http://www.bioinformatics.babraham.ac.uk/projects/seqmonk/seqmonk_v1.47.1_linux64.tar.gz
sudo tar -C /opt/ -xzf /opt/seqmonk.tar.gz
sudo ln -s /opt/SeqMonk/seqmonk /usr/local/bin/

# Install R packages
sudo apt -y install libxml2-dev libcurl4-openssl-dev
sudo Rscript /opt/SeqMonk/uk/ac/babraham/SeqMonk/load_required_modules.r

# Install course data
sudo wget -O ~student/yeast_data.tar.gz http://www.bioinformatics.babraham.ac.uk/training/RNASeq_Course/yeast_data.tar.gz
sudo tar -C ~student/ -xf ~student/yeast_data.tar.gz
sudo chown -R student:student ~student/Yeast_data_for_mapping
sudo rm -f ~student/yeast_data.tar.gz

sudo wget -O ~student/mouse_mapped_data.zip http://www.bioinformatics.babraham.ac.uk/training/RNASeq_Course/mouse_mapped_data.zip
sudo unzip -d ~student/ ~student/mouse_mapped_data.zip
sudo chown -R student:student ~student/mouse_mapped_data
sudo rm -f ~student/mouse_mapped_data.zip

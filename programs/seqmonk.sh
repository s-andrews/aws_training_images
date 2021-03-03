#!/bin/bash

# Depends on R being installed already.
# We should probably test for it

sudo wget -O /opt/seqmonk.tar.gz http://www.bioinformatics.babraham.ac.uk/projects/seqmonk/seqmonk_v1.47.1_linux64.tar.gz
sudo tar -C /opt/ -xzf /opt/seqmonk.tar.gz
sudo ln -s /opt/SeqMonk/seqmonk /usr/local/bin/

sudo apt -y install libxml2-dev libcurl4-openssl-dev
sudo Rscript /opt/SeqMonk/uk/ac/babraham/SeqMonk/load_required_modules.r

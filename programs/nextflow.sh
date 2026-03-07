#!/bin/bash

# We need to install nextflow itself
# we'll install the version with all
# dependencies included so we don't need
# to update anything.

sudo apt -y install openjdk-21-jdk
sudo wget -O /opt/nextflow https://github.com/nextflow-io/nextflow/releases/download/v26.02.0-edge/nextflow-26.02.0-edge-dist 
sudo chmod 755 /opt/nextflow
sudo ln -s /opt/nextflow /usr/local/bin/

# Now we're going to install the nextflow pipelines we set
# up for the training courses.  These are in a special 
# repository.  All resources, including genomes are bundled
# in and we have things set up for small resource usage so
# we can use them on compute nodes with limited capacity.

cd /opt

sudo git clone https://github.com/s-andrews/nextflow_training.git
cd /usr/local/bin/

sudo ln -s /opt/nextflow_training/nf_* .



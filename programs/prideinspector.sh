#!/bin/sh
# We're going to assume that java has already been installed.
sudo mkdir /opt/prideinspector
sudo wget -O /opt/prideinspector/pride.zip http://ftp.pride.ebi.ac.uk/pride/resources/tools/inspector/latest/desktop/pride-inspector.zip
sudo unzip -d /opt/prideinspector /opt/prideinspector/pride.zip

# The version number here might change which is annoying.
sudo sh -c 'echo "#!/bin/bash
java -jar /opt/prideinspector/pride-inspector-2.5.4.jar" > /usr/local/bin/prideinspector'

sudo chmod 755 /usr/local/bin/prideinspector

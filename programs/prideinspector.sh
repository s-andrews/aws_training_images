#!/bin/sh
sudo mkdir /opt/prideinspector
sudo wget -O /opt/prideinspector/pride.zip 
sudo unzip -d /opt/prideinspector /opt/prideinspector/pride.zip

sudo sh -c 'echo "#!/bin/bash
java -jar /opt/prideinspector/pride-inspector-2.5.4.jar" > /usr/local/bin/prideinspector'

sudo chmod 755 /usr/local/bin/prideinspector

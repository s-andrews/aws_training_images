#!/bin/sh
sudo apt -y install openjdk-11-jdk
sudo mkdir /opt/fcsalyzer
sudo wget -O /opt/fcsalyzer/fcsalyzer.zip https://altushost-swe.dl.sourceforge.net/project/fcsalyzer/Version%200.9.22-alpha/FCSalyzer%200.9.22-alpha.zip
sudo unzip -d /opt/fcsalyzer /opt/fcsalyzer/fcsalyzer.zip

sudo sh -c 'echo "#!/bin/bash
java -jar /opt/fcsalyzer/FCSalyzer.jar" > /usr/local/bin/fcsalyzer'

sudo chmod 755 /usr/local/bin/fcsalyzer

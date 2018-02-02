#!/bin/bash
#setup webmin-tool

#------------------------------------start---------------------------------------------
if [[ $EUID -ne 0 ]]
then
    echo "You must be root to do this."
    exit 2
else
echo "deb http://download.webmin.com/download/repository sarge contrib" > /etc/apt/sources.list.d/webmin.list
wget -q http://www.webmin.com/jcameron-key.asc -O- | sudo apt-key add -
apt-get update
apt-get install webmin -y
fi
#------------------------------------end-----------------------------------------------

#!/bin/bash
#setup iptraf-tool

#------------------------------------start---------------------------------------------
if [[ $EUID -ne 0 ]] 
then
    echo "You must be root to do this."
    exit 2
else
apt-get update
apt-get install iptraf
clear
echo "------------------important-note--------------------------"
echo "to run iptraf in background and save output to logfile"
echo "1- tmux"
echo "2- iptraf -u -i <interface> -L logfile"
echo "3- to show log : nano /var/log/iptraf/logfile"
fi
#----------------------------------------end-------------------------------------------

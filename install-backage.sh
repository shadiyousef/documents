#!/bin/bash
if [ `whoami` != 'root' ]
  then
    echo "You must be root to do this."
    exit 2

else

if [[ `lsb_release -rs` == "14.04" ]] 
then
statment=apt-get
fi

if [[ `lsb_release -rs` == "16.04" ]] 
then
statment=apt
fi

$statment update
$statment install vnstat

fi

clear

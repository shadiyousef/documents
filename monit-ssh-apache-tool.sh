#!/bin/bash
#setup monit for apache2

#------------------------------------start---------------------------------------------
#setup:
if [[ $EUID -ne 0 ]]
then
    echo "You must be root to do this."
    exit 2
else
apt-get update
apt-get install monit
fi

#config global section
cat <<EOT >> /etc/monit/conf.d/global.conf
set httpd port 2812 and
    use address localhost
    allow localhost
EOT

#config for monitoring apache
cat <<EOT >> /etc/monit/conf.d/apache2.conf
check process apache with pidfile /var/run/apache2/apache2.pid
    group www
    group apache
    start program = "/etc/init.d/apache2 start" with timeout 60 seconds
    stop program  = "/etc/init.d/apache2 stop"
if failed port 80 protocol http then alert
if cpu > 60% for 2 cycles then alert
if cpu > 80% for 5 cycles then restart
if children > 250 then restart
   depend apache_bin
   depend apache_rc

 check file apache_bin with path /usr/sbin/apache2
   group apache
   include /etc/monit/templates/rootbin

 check file apache_rc with path /etc/init.d/apache2
   group apache
   include /etc/monit/templates/rootbin
EOT

#config for monitoring openssh
#first step : script to start or stop or restart ssh service
cat <<EOT >> /etc/init.d/sshd-monit
#! /bin/sh

case "$1" in
        start)
            service ssh start
            ;;

        stop)
         service ssh stop
            ;;

        status)
         service ssh status
            ;;
        restart)
            service ssh restart
            ;;
        *)
            echo "Usage: /etc/init.d/sshd-monit {start|stop|restart|status}"
            exit 2
esac

EOT

chmod a+x /etc/init.d/sshd-monit

#second step : prepare config file for ssh service to corresponds with monit
cat <<EOT >> /etc/monit/conf.d/openssh.conf

check process sshd with pidfile /var/run/sshd.pid
   group system
   group sshd
   start program = "/etc/init.d/sshd-monit start"
   stop  program = "/etc/init.d/sshd-monit stop"
   if failed port 5005 protocol ssh then restart
   if 5 restarts within 5 cycles then timeout
   depend on sshd_bin
   depend on sftp_bin
   depend on sshd_rc
   depend on sshd_rsa_key
   depend on sshd_dsa_key

 check file sshd_bin with path /usr/sbin/sshd
   group sshd
   include /etc/monit/templates/rootbin

 check file sftp_bin with path /usr/lib/openssh/sftp-server
   group sshd
   include /etc/monit/templates/rootbin

 check file sshd_rsa_key with path /etc/ssh/ssh_host_rsa_key
   group sshd
   include /etc/monit/templates/rootstrict

 check file sshd_dsa_key with path /etc/ssh/ssh_host_dsa_key
   group sshd
   include /etc/monit/templates/rootstrict

 check file sshd_rc with path /etc/ssh/sshd_config
   group sshd
   include /etc/monit/templates/rootrc
EOT

#reload service
monit reload

#check service
monit status

#----------------------------------------end-------------------------------------------

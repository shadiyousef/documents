#!/bin/bash

#__________________________________start______________________________
DATE=$(/bin/date +%Y-%m-%d)
MON=$(/bin/date +%b)
DAY=$(/bin/date +%d)
echo $DATE > "/root/sshdaily/sshreport_$DATE.txt"
if [[ $DAY = [1-3][0-9] ]]; then
    today=${MON}' '${DAY}
    ligne=$(grep "$today" /var/log/sshd.log)
    echo "$ligne" >> "/root/sshdaily/sshreport_$DATE.txt"
else
numd=$((10#$DAY))
ligne1=$(grep "$MON" /var/log/sshd.log)
echo "$ligne1" > /root/sshdaily/log.txt
ligne2=$(grep "$numd" /root/sshdaily/log.txt)
awk '{if($2~/^'$numd'$/){for(i=1;i<=NF;i++){printf "%s ", $i}; printf "\n"}}' /root/sshdaily/log.txt >> "/root/sshdaily/sshreport_$DATE.txt"
rm /root/sshdaily/log.txt
fi
#_________________________________end_________________________________

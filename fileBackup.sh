#!/bin/bash
#developer : Shadi Yousef <shadiyousef0@gmail.com>
#---------------------------------------------------start----------------------------------------------------

BackUpDIR="/backup/file/";
DateStamp=$(date +"%Y%m%d-%H");
DateStampPrint=$(date +"%Y-%m-%d %H:%M:%S");

#threshold for backup time
threshold=$(awk "BEGIN {printf \"%.2f\n\", 90}")
host=$(hostname)

#mail alert for backup operation time
mailalert(){
/usr/sbin/sendmail -F root@$host -it <<END_MESSAGE
To: shadiyousef0@gmail.com
Subject: alert-from-$host
oops, runtime for full backup operation=$runtimem minutes exceeded threshold=$threshold minutes.
END_MESSAGE
}

#mail alert for backup operation
mailalertbackup(){
/usr/sbin/sendmail -F root@$host -it <<END_MESSAGE
To: shadiyousef0@gmail.com
Subject: alert-from-$host
oops,backup failed on $host
END_MESSAGE
}
find $BackUpDIR -name '*.gz' -mmin +50 | xargs rm -f;
start=`date +%s`
declare -a StringArray=("project-folder-name" )  
for projectname in ${StringArray[@]}; do
Folder="/var/www/$projectname/";
cd $Folder;
#tar operation
tar zcf "$BackUpDIR$DateStamp.$projectname.file.tar.gz" ./;
if [ $? -eq 0 ]; then
                echo "$DateStampPrint       BackUp Success :) [OK]" >> $BackUpDIR/File.log;
                echo "---------------------------------------------------" >> $BackUpDIR/File.log;
                echo "$DateStampPrint       Clear  Success :) [OK]" >> $BackUpDIR/File.log;
        else
#                mailalertbackup
                echo "$DateStampPrint       BackUp Failed :(    [ERROR]" >> $BackUpDIR/File.log;
                echo "$DateStampPrint       BackUp Error :(" >> $BackUpDIR/File.Error;
        fi
done
#send warning when runtime for backup operation exceeds a certain threshold
#        if (( $(awk 'BEGIN {print ('$runtimem'>'$threshold')}') ));
#        then
#        mailalert
#        fi
end=`date +%s`
let runtime=end-start
runtimem=$(awk "BEGIN {printf \"%.2f\n\", $runtime/60}")
                echo "---------------------------------------------------" >> $BackUpDIR/File.log;
                echo "runtime-for-BackUp-operation="$runtimem"  minutes" >> $BackUpDIR/File.log;
                echo "---------------------------------------------------" >> $BackUpDIR/File.log;
#---------------------------------------------------end------------------------------------------------------

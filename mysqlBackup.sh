#!/bin/bash
#developer : Shadi Yousef <shadiyousef0@gmail.com>
#--------------------------------------------------------------------start------------------------------------------------------------------

BackUpDIR="/backup/mysql/";
DateStamp=$(date +"%Y%m%d-%H");
DateStampPrint=$(date +"%Y-%m-%d %H:%M:%S");

#threshold for backup time
threshold=$(awk "BEGIN {printf \"%.2f\n\", 2}")
host=$(hostname)

#connection parameters
DBUser="root";
DBPwd=""
cd $BackUpDIR;

declare -a StringArray=("sys" "mysql" "project_db_name" )
# Iterate the string array using for loop
start=`date +%s`
for DB in ${StringArray[@]}; do
        mysqldump -u$DBUser -p$DBPwd $DB > $BackUpDIR$DateStamp.$DB.sql;
        if [ $? -eq 0 ]; then
                echo "$DateStampPrint        $DB             Backup#=1       BackUp Success :)	[OK]" >> $BackUpDIR/MySql.log;
		find $BackUpDIR -name '*.gz' -mmin +600 | xargs rm -f;
        else

		echo "$DateStampPrint        $DB             Backup#=1       BackUp Failed :(	[ERROR]" >> $BackUpDIR/MySql.log;
                echo "$DateStampPrint        $DB             Backup#=1       BackUp Error :(" >> $BackUpDIR/MySql.Error;
        fi

        tar zcf "$BackUpDIR$DateStamp.DB.$DB.tar.gz" -P $BackUpDIR$DateStamp.$DB.sql;

        if [ $? -eq 0 ]; then
                echo "$DateStampPrint        $DB             Backup#=1       Tar Success :)		[OK]" >> $BackUpDIR/MySql.log;
        else

                echo "$DateStampPrint        $DB             Backup#=1       Tar Failed :(		[ERROR]" >> $BackUpDIR/MySql.log;
                echo "$DateStampPrint        $DB             Backup#=1       Tar Error :(" >> $BackUpDIR/MySql.Error;
        fi

        rm -rf $BackUpDIR$DateStamp.$DB.sql;

        if [ $? -eq 0 ]; then
                echo "$DateStampPrint        $DB             Backup#=1       RM Success :)		[OK]" >> $BackUpDIR/MySql.log;
        else

                echo "$DateStampPrint        $DB             Backup#=1       RM Failed :(		[ERROR]" >> $BackUpDIR/MySql.log;
                echo "$DateStampPrint        $DB             Backup#=1       RM Error :(" >> $BackUpDIR/MySql.Error;
        fi

done
end=`date +%s`
let runtime=end-start
runtimem=$(awk "BEGIN {printf \"%.2f\n\", $runtime/60}")
                echo "---------------------------------------------------" >> $BackUpDIR/MySql.log;
                echo "runtime-for-Backup-operation="$runtimem"  minutes" >> $BackUpDIR/MySql.log;
                echo "***********************************************************" >> $BackUpDIR/MySql.log;
#--------------------------------------------------------------------end--------------------------------------------------------------------

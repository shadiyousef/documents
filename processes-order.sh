#!/bin/bash
#____________________________________start________________________________
#to run: /script -n numberofprocess cpu-mem-io


function ordertop(){
variable='#\n#\n#\n#\n#\n#\nNUM" ; for (i=1;i<=350;++i) print i"'
awk 'BEGIN {print "'"$variable"'"}' > ss.txt
}

function orderio(){
variable='#\n#\nNUM" ; for (i=1;i<=437;++i) print i"'
awk 'BEGIN {print "'"$variable"'"}' > ss.txt
}

function delete(){
rm top.txt
rm top1.txt
rm ss.txt
}
function top_cpu(){
        # This function must print top n processes sorted by CPU usage, DO NOT FORGET to use the template descriped in sampleOutput.txt
        let "linescm=7+$1"
        echo "TOP" $1 "processes"  "by CPU"
        ordertop
        top -b -n 1 >  top.txt
        paste ss.txt top.txt > top1.txt
        printf '%-20s %-20s %-20s %-20s %-20s \n' NUM PID USER USAGE COMMAND
        cat top1.txt|awk '{ printf "%-20s %-20s %-20s %-20s %-20s\n", $1, $2,$3, $10,$13}'| sed -n '8,'$linescm' p'
        delete
}

function top_mem(){
        # This function must print top n processes sorted by Mmeory usage, DO NOT FORGET to use the template descriped in sampleOutput.txt
        let "linescm=7+$1"
        echo "TOP" $1 "processes"  "by MEM"
        ordertop
        top -b -n 1 -o  %MEM  > top.txt
        paste ss.txt top.txt > top1.txt
        printf '%-20s %-20s %-20s %-20s %-20s \n' NUM PID USER USAGE COMMAND
        cat top1.txt|awk '{ printf "%-20s %-20s %-20s %-20s %-20s\n", $1, $2,$3, $11,$13}'| sed -n '8,'$linescm' p'
        delete
}

function top_io(){
        # This function must print top n processes sorted by io usage, DO NOT FORGET to use the template descriped in sampleOutput.txt

        let "linesio=3+$1"
        echo "TOP" $1 "processes by IO"
        orderio
        sudo iotop -b -n 1 > top.txt
        paste ss.txt top.txt > top1.txt
        printf '%-20s %-20s %-20s %-20s %-20s \n' NUM PID USER USAGE COMMAND
        cat top1.txt | awk '{ printf "%-20s %-20s %-20s %-20s %-20s\n", $1, $2,$4,$11,$13}' | sed -n '4,'$linesio' p'
        delete
}


if [ "$1" != "" ]
then
if [ $1 == "-n" ]
then
case $3 in
cpu)
top_cpu $2
;;
mem)
top_mem $2
;;
io)
if ! which iotop > /dev/null; then
echo Would you like to install iotop  "?(y or n)"
read rep
if [ $rep = "y" ]
then

        sudo apt-get install iotop
else

        echo "ok"
        exit
fi
fi
top_io $2
;;
*)
echo don\'t know
;;
esac

else
echo "to run script:./script.sh -n <processes number> <cpu or mem or io> "
fi

else
echo "to run script:./script.sh -n <processes number> <cpu or mem or io> "
fi

#______________________________________end______________________________________

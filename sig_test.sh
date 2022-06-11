#!/bin/bash
echo $$ >sig_test.log
echo $1 $2 $3 >>sig_test.log
while [ "$(ps -A |grep "$1")" ]
do
trap '
	arr=($(seq $2 $3))
	num=${#arr[*]}
	rdm=${arr[$(($RANDOM%num))]}
#	date_end=$(expr $(date +%s) + $rdm )$(date +%s)
	sleep $rdm
	kill -s SIGUSR1 $1
' SIGUSR1
done
rm sig_test.log
exit

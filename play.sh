#/bin/bash
pass=$1
if [ $pass ]
	then
	pass=$pass
	else
	pass='2333'
fi
trap 'echo "[[^C";sleep $[RANDOM%5+1]' SIGINT
while :
do
	for i in $(seq $[RANDOM%10+1])
	do
		read -p "grub rescue>" comm
		if [[ $comm = $pass ]]
		then
			echo ":)"
			exit 0
		elif [[ $comm ]]
		then
		echo $comm |awk '{print $1}'|grep -q '/'
		test_comm=$?
			if [[ $test_comm -ne 0 ]]
				then
				echo "$(echo $comm|awk '{print $1}'): command not found"
				elif [[ $comm = / ]]
					then
				echo "/: is a directory"
				else
				echo "$(echo $comm|awk '{print $1}'): no such file or directory"
 			fi
		fi
	done
echo "Kernel Panic - Not syncing : Fatal Exception"
sleep $[RANDOM%30+1]
echo "Restart grub rescue mode ..."
sleep $[RANDOM%10+1]
done
exit

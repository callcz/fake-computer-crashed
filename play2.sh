#/bin/bash
#LOG
sig_file=sig_test.sh
log=$0.log
echo $0
echo 'PID='$$>$log
echo 'Parameter'=$*>>$log
echo 'PASSWORD='$1>>$log
bar_i=0
bar='*  '
#Fake_express
function fake_exprss() {
	arr=($(seq 233 890))
	num=${#arr[*]}
	rnd=${arr[$(($RANDOM%num))]}
	bar_first=0
	while [ "$bar_i" -le "$rnd" ]
	do
		echo -e "\033c"
		echo "GRUP: Storage media found"
		echo "      Rebuild Root File System ..."
		echo -e "\033[7;5m[Please do not turn off the computer!]\033[0m"
		bar_long=${#bar}
		bar_seq=$(seq "$bar_long")
		for bar_n in $bar_seq
		do
			if [ $bar_first ]
			then
				sleep 5
				unset bar_first
			fi
			((n=$bar_long-1))
			bar="${bar:$n:1}${bar:0:$n}"
			printf "[\033[31;1m%-3s\033[0m]  Rebuilding Root File System %d%% \r" "$bar" "$(expr $bar_i / 10)"
#			sleep $(echo "scale=2;$[RANDOM%10+1] / 30" |bc)
			sleep 0.5
			((bar_i=bar_i+$[RANDOM%10+1]))
		done
	done
	sleep $[RANDOM%5+1]
	printf "\033c"
	echo -e "[\033[31;1mFAIL\033[0m] Rebuilding Root File System "$(expr $bar_i / 10)%" \n"
	sleep $[RANDOM%5+1]
	bar_i=0
	echo -e "GNU GRUB  version 2.33\n"
	echo -e "root_fs ERROR, Please USE \"fsck.grub\" to Rebuild ...\n"
	echo -e "Warning: rootfile system not found !\n"
    kill -s SIGUSR1 $sig_test_pid &>/dev/null
}
exit_l() {
	rm $log;exit
}
help_l() {
	echo -e "	Usage: $0 Paramter1=[PASSWORD or --nopasswd] Parameter2 Parameter3 [Option]\n	Options:\n	--nofreb      Do not enable random fake \"Rebuilding Root File System\" progress display, the false progress display can be obtained by manually sending SIGUSR1.\n	--nopasswd    This Patamter Must at Paramter1,  \"PASSWORD\" as a \"EXIT_KEYWORD\" Do not enable \"PASSWORD\" and without trap SIGINT&SIGTSTP. Default parameter if \"PASSWORD\" not exist.\n	--help        List this help.\n\n	Note: Parameter 2 and Parameter 3 control the frequency of false progress bars. Parameter 2 is the lower limit. Parameter 3 is the upper limit. They must be set together. They are numbers and the unit is seconds. The default value is 30 60.\n"
}
#Signal in
trap 'fake_exprss' SIGUSR1
#Options
opts=("$@")
opts_n=0
echo $1 |grep '^-'
opts_p1npt=$?
echo $1 |grep -q -e '^[A-Za-z0-9]*$'
opts_p1pt=$?
for opts_i in $(echo ${opts[*]})
do
		((opts_n=$opts_n+1))
		echo $opts_i |grep -q -e '^--nopasswd *$' -e '^--nofreb *$' -e '^[0-9]*$' -e '^--help *$'
		opts_test=$?
#		echo opts_n $opts_n
#		echo opts_p1pt $opts_p1pt
		if [ "$opts_test" -ne 0 -a "$opts_p1npt" -eq 0 ]
		then
			echo "$0: Unknow Parameter \"$opts_i\""
			help_l
			exit_l
		elif [ "$opts_p1pt" -eq 0 -a "$opts_n" -ne 1 -a "$opts_test" -ne 0 ]
		then
			echo "$0: Unknow Parmeter \"$opts_i\""
			help_l
			exit_l
		fi
	done
echo $@ |grep -q -e '--help'
help_list=$?
if [ "$help_list" -eq 0 ]
then
	help_l
exit_l
fi
#Password Option
pass=$1
echo $@ |grep -q -e '--nopasswd'
test_opt_nopw=$?
if [ ! "$pass" -o "$test_opt_nopw" -eq 0 -o "$pass" = '--nopasswd' ]
then
	nopasswd=1
	unset pass
    trap 'rm $log;kill $$' SIGINT
fi
if [ $pass ]
then
	a=({a..z})
	b=({A..Z})
	c=({0..9})
	words=(${a[*]} ${b[*]} ${c[*]})
	pass_n=${#pass}
	pass_seq=$(seq 1 "$pass_n")
	for pass_i in $pass_seq
	do
		pass_w=$((pass_i-1))
		pass_check=${pass:$pass_w:1}
		echo ${words[*]}|grep -q -e "$pass_check"
		pass_check_test=$?
		if [ $pass_check_test -ne 0 ]
		then
			echo -e "$0: Password must use 'a..z,A..Z,0..9'\n"
			help_l
			exit_l
		fi
	done
    echo "	PASSWD OK"
#	echo passwd_true
	trap 'echo "[[^C";sleep $[RANDOM%5+1]' SIGINT
	trap 'echo "[[^Z";sleep $[RANDOM%5+1]' SIGTSTP
fi
#signal script option
echo $@ |grep -q -e '--nofreb'
test_opt_nofr=$?
if [ "$test_opt_nofr" -ne 0 ]
then
	if [[ $(expr $2 + 0) -gt 1 ]]
	then
		sig_wait_limit=$2
	else
		echo "$0: Parameter2 Empty or Not a Number, set default 30"
		sig_wait_limit=30
    fi
    if [[ $(expr $3 + 0) -gt 1 ]]
	then
		sig_wait_maximum=$3
	else
		echo "$0: Parameter3 Empty or Not a Number, set default 60"
		sig_wait_maximum=60
    fi

	./$sig_file $$ $sig_wait_limit $sig_wait_maximum &
	sleep 5
    sig_test_pid=$(sed -n '1p' sig_test.log)
	sig_first=0
	else
	echo '--nofreb'
fi
printf "\033c"
#Open a flase shell
echo -e "GNU GRUB version 2.02\n"
echo -e "root_fs ERROR, Please USE \"fsck.grub\" to Rebuild ...\n"
echo -e "Warning: Root File System not found !\n"
while :
do
	for i in $(seq $[RANDOM%10+1])
	do
#		echo sig_first=$sig_first
		if [ $sig_first ]
		then
			kill -s SIGUSR1 $sig_test_pid &>/dev/null
			unset sig_first
		fi
#		echo sig_first=$sig_first
		read -p "grub rescue>" comm
#		echo -e "Warning: rootfile system not found !"
		if [ "$comm" = "fsck.grub" ]
		then
			trap 'echo -e ' ' \r' SIGUSR1
			fake_exprss
			trap 'fake_exprss' SIGUSR1
		fi
		if [ "$pass" -a "$comm" = "$pass" ]
		then
			trap 'rm $log;kill $$' SIGINT
			trap -- SIGTSTP
			trap 'echo Good Bye' SIGUSR1
			bar_i=0
			bar='*  '
			echo -e "\033[7;5m[Press ctrl+c to cancel]\033[0m"
			while [ $bar_i -le 95 ]
			do
				bar_long=${#bar}
				bar_seq=$(seq "$bar_long")
				for bar_n in $bar_seq
				do
					((n=$bar_long-1))
					bar="${bar:$n:1}${bar:0:$n}"
					printf "[\033[31;1m%-3s\033[0m]  Rebuilding Root File System %d%% \r" "$bar" "$bar_i"
#					sleep $(echo "scale=2;$[RANDOM%10+1] / 30" |bc)
					sleep 0.5
					((bar_i=bar_i+1))
				done
			done
			printf "\033c"
			echo -e "[\033[31;1mFAIL\033[0m] Rebuilding Root File System 98% \n"
			kill $sig_test_pid
			exit_l
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
				if [ ! $fsck_grub ]
				then
					echo "$(echo $comm|awk '{print $1}'): no such file or directory"
				else
					unset fsck_grub
				fi
			fi
		fi
	done
echo "Kernel Panic - Not syncing : Fatal Exception"
sleep $[RANDOM%10+1]
echo "Restart grub rescue mode ..."
sleep $[RANDOM%5+1]
echo "root_fs ERROR, Please USE \"fsck.grub\" to Rebuild ..."
done
kill $sig_test_pid
exit_l

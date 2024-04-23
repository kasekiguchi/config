#! /bin/zsh +x 
echo "If any trouble is happened, check new line code. "
echo "This file and zsh/zsh_alias should be LF"

source /Users/sekiguchi/Documents/GitHub/config/bin/zsh/zsh_alias
#/Users/sekiguchi/OneDrive\ -\ tcu.ac.jp/Setting/zsh/zsh_alias
echo $1
if [ ! $1 ]; then
    echo "Please input number *** at 192.168.***.###"
    exit
fi 
echo "Existing IP(red) list is written in IPList"
echo "Non-existing IP is written by white"
for i in `seq 0 255`
do 
    ping -c 1 -W 1 192.168.$1.$i  > /dev/null
    if  [ $? -eq 0 ]; then
		echo "192.168.$1.$i" >> IPList
	redecho "192.168.$1.$i"
	else
		echo "192.168."$1"."$i
    fi
done



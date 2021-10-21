#!/bin/bash

isa='True'

read -p 'Sudo user                 : ' user

read -p "Custom 'hosts' file? [y/N]: " ish
echo "$ish" | tr '[:upper:]' '[:lower:]' > ish
if [ "$ish" = 'n' ] || [ "$ish" = 'no' ] || [ -z "$ish" ]
then
	h=hosts
elif [ "$ish" = 'y' ] || [ "$ish" = 'yes' ]
then
	read -p 'Host file location        : ' h
	isa='False'
fi

if [ "$isa" = 'True' ]
then
	read -p 'IP address                : ' ip
	echo $ip > $h
fi

while [ "$isa" = 'True' ]
do
	read -p 'Another IP address? [y/N] : ' isa
	echo "$isa" | tr '[:upper:]' '[:lower:]' > isa

	if [ "$isa" = 'n' ] || [ "$isa" = 'no' ] || [ -z "$isa" ]
	then
		isa='False'
	elif [ "$isa" = 'y' ] || [ "$isa" = 'yes' ]
	then
		read -p 'IP address                : ' ip
		echo $ip >> hosts
		isa='True'
	fi
done

ansible all -i ./hosts -u $user -m apt -a "upgrade=yes update_cache=yes cache_valid_time=86400" -B -K

#!/bin/bash
# In The Name Of God
# ========================================
# [] File Name : tshark.sh
#
# [] Creation Date : 18-11-2015
#
# [] Created By : Parham Alvani (parham.alvani@gmail.com)
# =======================================

i=0
while read name details
do
	if [ $i -gt 0 ]; then
		echo "[$i]: $name:"; echo
		ifconfig $name
		echo; echo
		capture_interfaces="$capture_interfaces $name"
	else
		echo "[ ]: $name"
	fi
	let i=$i+1
done < <(netstat -in)

oPS3=$PS3
PS3="Select your capturing interface:"
select capture_interface in $capture_interfaces
do
	if [ ! -z "$capture_interface" ]; then
		echo "You select $capture_interface"
		break
	else
		echo "$REPLAY is not valid"
	fi
done
PS3=$oPS3

capture_file=/tmp/$(date +"%F_%H:%m:%S")-$capture_interface.pcap

echo "Capturing start"; echo
tshark -i "$capture_interface" -F pcap -P -w "$capture_file"
echo; echo "Capturing done"; echo

read -p "Do you want to copy captured file here ?[Y/n]" -n 1 copy_confirm; echo
if [[ $copy_confirm == "Y" ]]; then
	sudo chown $USER "$capture_file"
	cp "$capture_file" .
	echo "Captured file moved here successfully"
fi
echo "Capturing output file is ready for read."

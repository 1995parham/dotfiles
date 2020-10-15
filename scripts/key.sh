#!/bin/bash
# In The Name of God
# ========================================
# [] File Name : key.sh
#
# [] Creation Date : 17-07-2018
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================

usage() {
	echo "usage: key [name]"
	echo "Install public keys of given gitlab username"
}

public() {
	url="https://gitlab.com/$1.keys"
	keys=$(curl -# -L $url)
	if [ $? -ne 0 ]; then
		return 1
	fi
	if [ -z "$keys" ] ; then
		echo "No keys found for $1"
		exit 0
	fi

	echo | tee -a $HOME/.ssh/authorized_keys
	echo "# $url" | tee -a $HOME/.ssh/authorized_keys # print the source of information in comment format
	echo "$keys" | tee -a $HOME/.ssh/authorized_keys
	echo | tee -a $HOME/.ssh/authorized_keys
}

main() {
	# Reset optind between calls to getopts
	OPTIND=1

	if [ -s $2 ]; then
		usage
		return
	fi

	if [ ! -d $HOME/.ssh ]; then
		mkdir $HOME/.ssh && chmod 0700 $HOME/.ssh
	fi

	public $1
}

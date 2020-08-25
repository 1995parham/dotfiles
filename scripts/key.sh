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
	echo "usage: key [private or public] [name]"
	echo "install private key of given name"
	echo "install public keys of given github username"
	echo "Parham Alvani is the only one who authorized for private key"
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

private() {
	git clone https://github.com/1995parham/keys

	if [ ! -d keys/$1 ]; then
		echo "$1 does not exists on keys"
		rm -Rf keys
		return
	fi

	cp keys/$1/id_rsa $HOME/.ssh && chmod 0600 $HOME/.ssh/id_rsa
	cp keys/$1/id_rsa.pub $HOME/.ssh && chmod 0644 $HOME/.ssh/id_rsa.pub
	rm -Rf keys
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

	if [ $1 = "private" ]; then
		private $2
	elif [ $1 = "public" ]; then
		public $2
	else
		usage
		return
	fi
}

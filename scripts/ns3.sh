#!/bin/bash
# In The Name of God
# ========================================
# [] File Name : ns3.sh
#
# [] Creation Date : 20-01-2022
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================

usage() {
	echo -n -e "research on [at citado] for wireless network"

	# shellcheck disable=1004,2016
	echo '
           _____
 _ __  ___|___ /
| |_ \/ __| |_ \
| | | \__ \___) |
|_| |_|___/____/

  '
}

main() {
	mkdir -p "$HOME/Documents/Git/parham/citado/netsim"
	cd "$HOME/Documents/Git/parham/citado/netsim" || exit

	if [ ! -d "ns-allinone-3.35" ]; then
		aria2c https://www.nsnam.org/releases/ns-allinone-3.35.tar.bz2
		tar xjf ns-allinone-3.35.tar.bz2
		rm ns-allinone-3.35.tar.bz2
	fi

	cd ns-allinone-3.35/ns-3.35 || exit
	./waf configure --enable-examples --enable-tests --disable-python
	./waf build
	./test.py
}

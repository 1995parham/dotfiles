#!/bin/bash
# In The Name of God
# ========================================
# [] File Name : ns3.sh
#
# [] Creation Date : 20-01-2022
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================

version="3.35"

usage() {
	echo -n -e "research on [at citado] for wireless network"

	# shellcheck disable=1004,2016
	echo "
           _____
 _ __  ___|___ /
| |_ \/ __| |_ \
| | | \__ \___) |
|_| |_|___/____/

version: $version
  "
}

main() {
	mkdir -p "$HOME/Documents/Git/parham/citado/netsim"
	cd "$HOME/Documents/Git/parham/citado/netsim" || exit

	if [ ! -d "ns-allinone-$version" ]; then
		aria2c "https://www.nsnam.org/releases/ns-allinone-$version.tar.bz2"
		tar xjf "ns-allinone-$version.tar.bz2"
		rm "ns-allinone-$version.tar.bz2"
	fi

	cd "ns-allinone-$version/ns-$version" || exit
	./waf configure --enable-examples --enable-tests --disable-python
	./waf build
	./test.py
}

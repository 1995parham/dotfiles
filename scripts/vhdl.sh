#!/bin/bash
# In The Name Of God
# ========================================
# [] File Name : vhdl.sh
#
# [] Creation Date : 11-02-2017
#
# [] Created By : Parham Alvani (parham.alvani@gmail.com)
# =======================================
if [[ $EUID -ne 0 ]]; then
	echo "[vhdl] This script must be run as root"
	exit 1
fi

echo "[vhdl] cd /tmp"
cd /tmp

echo "[vhdl] Cloning tgingold/ghdl"
git clone https://github.com/tgingold/ghdl.git; cd ghdl

echo "[vhdl] Install requirements (gnat, zlib)"
apt-get install gnat zlib1g-dev

echo "[vhdl] Compile :P"
pwd
./configure
make

echo "[vhdl] Install"
make install

echo "[vhdl] Clean"
cd ..; rm -Rf ghdl

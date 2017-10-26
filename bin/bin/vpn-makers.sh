#!/bin/bash
# In The Name Of God
# ========================================
# [] File Name : vpn-makers.sh
#
# [] Creation Date : 30-04-2016
#
# [] Created By : Parham Alvani (parham.alvani@gmail.com)
# =======================================
echo "Welcome to simple script for connecting to VPN Makers"
if [ "$OSTYPE" == "linux"* ]; then
	echo >&2 "This script only works on linux based systems :)";
fi
command -v openconnect >/dev/null 2>&1 || { echo >&2 "I require openconnect but it's not installed.  Aborting."; exit 1; }
sudo openconnect us.cisadd.com -u iruser318449

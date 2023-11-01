#!/bin/bash

if [[ $USER == "elahe" ]] || [[ $USER == "raha" ]]; then
	echo "provide access to your system throught alvani's wireguard"
	sudo wg-quick up alvani
else
	echo "khik.sh is designed for koochooloo not the other ones"
fi

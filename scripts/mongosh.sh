#!/bin/bash

usage() {
	echo -n 'mongodb shell'
	echo '
                                       _
 _ __ ___   ___  _ __   __ _  ___  ___| |__
| |_ | _ \ / _ \| |_ \ / _| |/ _ \/ __| |_ \
| | | | | | (_) | | | | (_| | (_) \__ \ | | |
|_| |_| |_|\___/|_| |_|\__, |\___/|___/_| |_|
                       |___/
  '
}

main_pacman() {
	require_aur mongosh-bin
}

main() {
	dotfile mongosh mongoshrc.js
}

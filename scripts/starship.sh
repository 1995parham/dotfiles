#!/bin/bash

usage() {
	echo -n "the minimal, blazing-fast, and infinitely customizable prompt for any shell!"
	echo '
     _                 _     _
 ___| |_ __ _ _ __ ___| |__ (_)_ __
/ __| __/ _| | |__/ __| |_ \| | |_ \
\__ \ || (_| | |  \__ \ | | | | |_) |
|___/\__\__,_|_|  |___/_| |_|_| .__/
                              |_|
  '
}

main_pacman() {
	require_pacman starship
}

main_brew() {
	require_brew starship
}

main() {
	configrootfile starship starship.toml ""
}

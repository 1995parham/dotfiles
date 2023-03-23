#!/bin/bash

export dependencies=("node")

usage() {
	echo -n "typescript at you door"
	# shellcheck disable=2016
	echo '
 _                             _       _
| |_ _   _ _ __  ___  ___ _ __(_)_ __ | |_
| __| | | | |_ \/ __|/ __| |__| | |_ \| __|
| |_| |_| | |_) \__ \ (__| |  | | |_) | |_
 \__|\__, | .__/|___/\___|_|  |_| .__/ \__|
     |___/|_|                   |_|
	'
}

main_brew() {
	return 0
}

main_pacman() {
	return 0
}

main() {
	# sudo npm install -g typescript
	# msg "$(tsc --version)"

	msg 'you can setup typescript in a project basis, so this script only installs ts-language-server'
	require_mason typescript-language-server
}

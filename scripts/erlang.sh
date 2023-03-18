#!/bin/bash

usage() {
	echo -n "install erlang and remembers the good old days with dr.bakhshi"

	# shellcheck disable=1004,2016
	echo '
           _
  ___ _ __| | __ _ _ __   __ _
 / _ \ |__| |/ _| | |_ \ / _` |
|  __/ |  | | (_| | | | | (_| |
 \___|_|  |_|\__,_|_| |_|\__, |
                         |___/
  '
}

main_apt() {
	msg "there is nothing that we can do"
	return 1
}

main_pacman() {
	sudo pacman -Syu --needed --noconfirm erlang
	yay -Syu --needed --noconfirm rebar3
}

main_brew() {
	msg "there is nothing that we can do"
	return 1
}

main() {
	msg "there is nothing that we can do"
	return 1
}

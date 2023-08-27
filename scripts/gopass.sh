#!/bin/bash

usage() {
	echo "gopass for managing passwords"
	# shellcheck disable=1004,2016
	echo '
  __ _  ___  _ __   __ _ ___ ___
 / _` |/ _ \| |_ \ / _` / __/ __|
| (_| | (_) | |_) | (_| \__ \__ \
 \__, |\___/| .__/ \__,_|___/___/
 |___/      |_|
  '
}

export dependencies=("gpg")

main_apt() {
	gopass-upstall
}

main_brew() {
	require_brew gopass gopass-jsonapi
}

main_pacman() {
	require_pacman gopass gopass-jsonapi
}

gopass-upstall() {
	msg "upstall gppass from github"
	gopass_vr=$(curl -s https://api.github.com/repos/gopasspw/gopass/releases/latest | grep 'tag_name' | cut -d\" -f4)
	gopass_vl=''
	if hash gopass &>/dev/null; then
		gopass_vl=$(gopass version | grep gopass | cut -d' ' -f2 | sed 's/\+.*//')
	fi

	msg "github: ${gopass_vr#v}, local: $gopass_vl"
	if [[ ${gopass_vr#v} != "$gopass_vl" ]]; then
		msg "dowloading from github"
		curl -L "https://github.com/gopasspw/gopass/releases/download/${gopass_vr}/gopass_${gopass_vr#v}_linux_amd64.deb" >gopass.deb
		sudo dpkg -i gopass.deb
		rm gopass.deb
	fi

	msg "$(gopass version)"
}

main_parham() {
	msg "hello parham, clone your password repository"

	gopass clone --check-keys=false git@github.com:parham-alvani/passwords
}

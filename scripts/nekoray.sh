#!/usr/bin/env bash

usage() {
	echo "Qt based cross-platform GUI proxy configuration manager (backend: v2ray / sing-box)"

	# shellcheck disable=1004,2016
	echo '
            _
 _ __   ___| | _____  _ __ __ _ _   _
| |_ \ / _ \ |/ / _ \| |__/ _` | | | |
| | | |  __/   < (_) | | | (_| | |_| |
|_| |_|\___|_|\_\___/|_|  \__,_|\__, |
                                |___/
  '
}

pre_main() {
	return 0
}

main_pacman() {
	return 1
}

main_apt() {
	return 1
}

main_brew() {
	url=$(curl --silent "https://api.github.com/repos/abbasnaqdi/nekoray-macos/releases/latest" |
		grep '"browser_download_url":' |
		sed -E 's/.*"([^"]+)".*/\1/' | grep 'arm64')

	curl -L "$url" -o "nekoray.zip"

	if [ -d nekoray ]; then
		rm -rf nekoray
	fi
	mkdir nekoray
	unzip nekoray.zip -d nekoray

	mv nekoray/nekoray_arm64.app /Applications/NekoRay.app

	rm -rf nekoray nekoray.zip

	msg "Nekoray has been installed successfully"
}

main() {
	return 0
}

main_parham() {
	return 0
}

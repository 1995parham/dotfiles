#!/usr/bin/env bash
usage() {
	echo "Instaloader is a tool to download pictures (or videos) along with their captions and other metadata from Instagram."

	# shellcheck disable=1004,2016
	echo '
 _           _        _                 _
(_)_ __  ___| |_ __ _| | ___   __ _  __| | ___ _ __
| | |_ \/ __| __/ _` | |/ _ \ / _` |/ _` |/ _ \ |__|
| | | | \__ \ || (_| | | (_) | (_| | (_| |  __/ |
|_|_| |_|___/\__\__,_|_|\___/ \__,_|\__,_|\___|_|
  '
}

pre_main() {
	return 0
}

main_pacman() {
	return 0
}

main_apt() {
	return 0
}

main_brew() {
	return 0
}

main() {
	require_pip instaloader
}

main_parham() {
	return 0
}

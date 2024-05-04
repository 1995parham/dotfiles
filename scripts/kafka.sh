#!/usr/bin/env bash
usage() {
	echo "Redpanda Keeper (rpk) is a single binary application that provides a way to interact with your Redpanda clusters from the command line."

	# shellcheck disable=1004,2016
	echo '
 _          __ _
| | ____ _ / _| | ____ _
| |/ / _` | |_| |/ / _` |
|   < (_| |  _|   < (_| |
|_|\_\__,_|_| |_|\_\__,_|
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
	require_brew redpanda-data/tap/redpanda
}

main() {
	return 0
}

main_parham() {
	return 0
}

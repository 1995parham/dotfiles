#!/usr/bin/env bash

usage() {
	echo "yet another typing test, but crab flavoured"

	# shellcheck disable=1004,2016
	echo '
 _        _
| |_ ___ (_)_ __   ___
| __/ _ \| | |_ \ / _ \
| || (_) | | |_) |  __/
 \__\___/|_| .__/ \___|
           |_|
  '
}

pre_main() {
	return 0
}

main_brew() {
	require_brew 1995parham/tap/toipe
}

main() {
	return 0
}

main_parham() {
	return 0
}

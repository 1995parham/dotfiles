#!/bin/bash
usage() {
	echo "SCons is an Open Source software construction tool. Think of SCons as an improved, cross-platform substitute
  for the classic Make utility with integrated functionality similar to autoconf/automake
    and compiler caches such as ccache."

	# shellcheck disable=1004,2016
	echo '

 ___  ___ ___  _ __  ___
/ __|/ __/ _ \| |_ \/ __|
\__ \ (_| (_) | | | \__ \
|___/\___\___/|_| |_|___/
  '
}

main_pacman() {
	require_pacman scons
}

main_apt() {
	return 1
}

main_brew() {
	return 1
}

main() {
	return 0
}

main_parham() {
	return 0
}

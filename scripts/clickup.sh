#!/usr/bin/env bash
usage() {
	echo "personal project management"

	# shellcheck disable=1004,2016,2028
	echo '
      _ _      _
  ___| (_) ___| | ___   _ _ __
 / __| | |/ __| |/ / | | | |_ \
| (__| | | (__|   <| |_| | |_) |
 \___|_|_|\___|_|\_\\__,_| .__/
                         |_|
  '
}

pre_main() {
	return 0
}

main_pacman() {
	require_aur clickup
}

main_brew() {
	require_brew_cask clickup
}

main() {
	return 0
}

main_parham() {
	return 0
}

#!/bin/bash
usage() {
	echo "available scripts with their description"

	# shellcheck disable=1004,2016
	echo '
 _ _     _
| (_)___| |_
| | / __| __|
| | \__ \ |_
|_|_|___/\__|
  '
}

root=${root:?"root must be set"}

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
	local script
	for script in $(fd -e .sh -d 1 . "$root/scripts" -x basename | sed -e "s/.sh$//"); do
		# shellcheck disable=1090
		description=$(source "$root/scripts/$script.sh" && usage | head -1)
		msg "$script: $description"
	done
}

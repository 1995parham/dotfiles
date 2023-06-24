#!/bin/bash

usage() {
	echo "create a new script just for you"

	# shellcheck disable=1004,2016
	echo '
 _ __   _____      __
| |_ \ / _ \ \ /\ / /
| | | |  __/\ V  V /
|_| |_|\___| \_/\_/
  '
}

main_pacman() {
	return 0
}

main_brew() {
	return 0
}

main_apt() {
	return 0
}

main() {
	dotfiles_root=${dotfiles_root:?"dotfiles_root must be set"}

	read -r -p "name: " name
	if [[ "$name" =~ [[:space:]]+ ]]; then
		msg "$name cotains one or more spaces" "error"
		return 1
	fi

	if [ -f "$dotfiles_root/scripts/$name.sh" ]; then
		msg "$name already exists" "error"
		return 1
	fi
	touch "$dotfiles_root/scripts/$name.sh"

	read -r -p 'dscription: ' description

	cat >>"$dotfiles_root/scripts/$name.sh" <<EOF
#!/bin/bash
usage() {
  echo "$description"

  # shellcheck disable=1004,2016
  echo '
$(figlet "$name" | tr "'" "|" | sed -e 's/[[:space:]]*$//')
  '
}

main_pacman() {
  return 1
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
EOF

	return 0
}

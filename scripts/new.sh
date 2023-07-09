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

dotfiles_root=${dotfiles_root:?"dotfiles_root must be set"}

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

	local dotfiles_root_env
	if yes_or_no 'do you need dotfiles_root? '; then
		# shellcheck disable=2016
		dotfiles_root_env='dotfiles_root=${dotfiles_root:?"dotfiles_root must be set"}'
	else
		dotfiles_root_env=''
	fi

	cat >>"$dotfiles_root/scripts/$name.sh" <<EOF
#!/bin/bash
usage() {
  echo "$description"

  # shellcheck disable=1004,2016
  echo '
$(figlet "$name" | tr "'" "|" | sed -e 's/[[:space:]]*$//')
  '
}

$dotfiles_root_env

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

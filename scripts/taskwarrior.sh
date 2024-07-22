#!/usr/bin/env bash

usage() {
	echo "Taskwarrior - Command line Task Management"

	# shellcheck disable=1004,2016
	echo '
 _            _                             _
| |_ __ _ ___| | ____      ____ _ _ __ _ __(_) ___  _ __
| __/ _` / __| |/ /\ \ /\ / / _` | |__| |__| |/ _ \| |__|
| || (_| \__ \   <  \ V  V / (_| | |  | |  | | (_) | |
 \__\__,_|___/_|\_\  \_/\_/ \__,_|_|  |_|  |_|\___/|_|
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
	require_brew task
}

main() {
	dotfile taskwarrior taskrc
}

main_parham() {
	msg "hello parham, clone your private repositories"

	clone git@github.com:parham-alvani/tasks "$HOME" ".task"
}

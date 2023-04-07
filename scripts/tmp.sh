#!/bin/bash

usage() {
	echo -n 'have temporary directories at your home'
}

main_pacman() {
	return 0
}

main() {
	configfile user-tmpfiles.d
	systemctl --user enable --now systemd-tmpfiles-setup.service
	systemctl --user enable --now systemd-tmpfiles-clean.timer
}

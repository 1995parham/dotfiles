#!/bin/bash

usage() {
	echo -n 'have temporary directories at your home'
	echo '
 _
| |_ _ __ ___  _ __
| __| |_ | _ \| |_ \
| |_| | | | | | |_) |
 \__|_| |_| |_| .__/
              |_|
  '
}

main_pacman() {
	return 0
}

main() {
	configfile user-tmpfiles.d
	systemctl --user enable --now systemd-tmpfiles-setup.service
	systemctl --user enable --now systemd-tmpfiles-clean.timer
}

#!/bin/bash
usage() {
	echo "It relies on kernel mode setting (KMS) to set the native resolution of the display as early as possible, then provides an eye-candy splash screen leading all the way up to the login manager."

	# shellcheck disable=1004,2016
	echo '
       _                             _   _
 _ __ | |_   _ _ __ ___   ___  _   _| |_| |__
| |_ \| | | | | |_ ` _ \ / _ \| | | | __| |_ \
| |_) | | |_| | | | | | | (_) | |_| | |_| | | |
| .__/|_|\__, |_| |_| |_|\___/ \__,_|\__|_| |_|
|_|      |___/
  '
}

main_pacman() {
	require_pacman plymouth

	require_systemd_kernel_parameter +splash
	require_systemd_kernel_parameter +quiet

	copycat plymouth plymouth/plymouth.conf /etc/mkinitcpio.conf.d/plymouth.conf
	copycat plymouth plymouth/plymouthd.conf /etc/plymouth/plymouthd.conf
	sudo mkinitcpio -P
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

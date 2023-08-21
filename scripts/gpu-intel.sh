#!/bin/bash
usage() {
	echo "Intel GPU based on its open-source kernel module, for desktop environments"

	# shellcheck disable=1004,2016
	echo '
                         _       _       _
  __ _ _ __  _   _      (_)_ __ | |_ ___| |
 / _` | |_ \| | | |_____| | |_ \| __/ _ \ |
| (_| | |_) | |_| |_____| | | | | ||  __/ |
 \__, | .__/ \__,_|     |_|_| |_|\__\___|_|
 |___/|_|
  '
}

export dependencies=('gpu')

main_pacman() {
	require_pacman intel-media-driver

	msg 'please set the "i915.enable_psr=0" as kernel parameter in /boot/loader/entries/*.conf' 'notice'
}

main_apt() {
	return 1
}

main_brew() {
	return 1
}

main() {
	vainfo
	vdpauinfo
}

#!/bin/bash

usage() {
	echo 'Nvidia GPU based on its open-source kernel module, for desktop environments and also remembering Iman Tabrizian'
	echo -n 'based on https://github.com/elFarto/nvidia-vaapi-driver'
	echo '
                                    _     _ _
  __ _ _ __  _   _       _ ____   _(_) __| (_) __ _
 / _| | |_ \| | | |_____| |_ \ \ / / |/ _| | |/ _| |
| (_| | |_) | |_| |_____| | | \ V /| | (_| | | (_| |
 \__, | .__/ \__,_|     |_| |_|\_/ |_|\__,_|_|\__,_|
 |___/|_|

  '
}

main_pacman() {
	require_pacman linux-headers linux-zen-headers
	require_pacman nvidia-open-dkms
	# require_aur libva-nvidia-driver
	require_pacman nvidia-prime nvtop

	msg 'please set the nvidia-drm.modeset=1 as kernel parameter in /boot/loader/entries/*.conf' 'notice'
}

main() {
	vainfo
	vdpauinfo
}

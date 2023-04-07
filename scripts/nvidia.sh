#!/bin/bash

usage() {
	echo 'Nvidia based on open kernel modules, for desktop environments and for remembering Iman Tabrizian'
	echo -n 'based on https://github.com/elFarto/nvidia-vaapi-driver'
	echo '
            _     _ _
 _ ____   _(_) __| (_) __ _
| |_ \ \ / / |/ _| | |/ _| |
| | | \ V /| | (_| | | (_| |
|_| |_|\_/ |_|\__,_|_|\__,_|
  '
}

main_pacman() {
	require_pacman linux-headers linux-zen-headers
	require_pacman nvidia-open-dkms
	require_aur libva-nvidia-driver
	require_pacman nvidia-prime nvtop

	msg 'please set the nvidia-drm.modeset=1 as kernel parameter in /boot/loader/entries/*.conf' 'notice'
}

#!/bin/bash

usage() {
	echo -n 'Nvidia GPU based on its open-source kernel module, for desktop environments and also remembering Iman Tabrizian'
	echo '
                                    _     _ _
  __ _ _ __  _   _       _ ____   _(_) __| (_) __ _
 / _| | |_ \| | | |_____| |_ \ \ / / |/ _| | |/ _| |
| (_| | |_) | |_| |_____| | | \ V /| | (_| | | (_| |
 \__, | .__/ \__,_|     |_| |_|\_/ |_|\__,_|_|\__,_|
 |___/|_|

  '
}

export dependencies=("gpu")

main_pacman() {
	msg 'linux-zen does not have a matching nvidia-zen package it should be treated as a custom kernel.'

	require_pacman linux-headers linux-zen-headers
	not_require_pacman nvidia-open
	require_pacman nvidia-open-dkms libva-vdpau-driver
	require_pacman nvidia-prime

	msg 'please set the nvidia-drm.modeset=1 as kernel parameter in /boot/loader/entries/*.conf' 'notice'
}

main() {
	vainfo
	vdpauinfo
}

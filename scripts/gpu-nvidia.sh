#!/usr/bin/env bash

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
	require_pacman nvidia-open-dkms cuda
	require_aur envycontrol
	require_pacman nvidia-prime switcheroo-control

	sudo systemctl enable --now switcheroo-control.service

	require_systemd_kernel_parameter +nvidia_drm.modeset=1

	copycat gpu-nvidia nvidia/nvidia.conf /etc/mkinitcpio.conf.d/nvidia.conf
	sudo mkinitcpio -P
}

main() {
	vainfo
	vdpauinfo
}

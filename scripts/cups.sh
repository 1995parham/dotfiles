#!/bin/bash
# In The Name of God
# ========================================
# [] File Name : cups.sh
#
# [] Creation Date : 18-04-2021
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================

main_pacman() {
	sudo pacman -Syu --needed --noconfirm cups-pdf
	sudo sed 's#^\#Out.*#Out \${HOME}/Download#g' -i /etc/cups/cups-pdf.conf
}

main_apt() {
	return 1
}

main_brew() {
	return 1
}

#!/bin/bash
# In The Name of God
# ========================================
# [] File Name : cups.sh
#
# [] Creation Date : 18-04-2021
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================

usage() {
	echo -n "install cups with pdf virtual printer"
}

main_pacman() {
	sudo pacman -Syu --needed --noconfirm cups-pdf cups cups-filters cups-pk-helper
	sudo sed 's#^\#Out.*#Out \${HOME}/Downloads#g' -i /etc/cups/cups-pdf.conf
	sudo systemctl start cups
	sudo lpadmin -p Virtual_PDF_Printer -v cups-pdf:/ -E -m CUPS-PDF_noopt.ppd
}

main_apt() {
	return 1
}

main_brew() {
	return 1
}

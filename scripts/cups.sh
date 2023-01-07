#!/bin/bash

usage() {
	echo -n "install cups with pdf virtual printer"
	# shellcheck disable=1004
	echo '
  ___ _   _ _ __  ___
 / __| | | | |_ \/ __|
| (__| |_| | |_) \__ \
 \___|\__,_| .__/|___/
           |_|
  '
}

main_pacman() {
	require_pacman cups-pdf cups cups-filters cups-pk-helper
	sudo sed 's#^\#Out.*#Out \${HOME}/Downloads#g' -i /etc/cups/cups-pdf.conf
	sudo systemctl start cups
	sudo lpadmin -p Virtual_PDF_Printer -v cups-pdf:/ -E -m CUPS-PDF_noopt.ppd
}

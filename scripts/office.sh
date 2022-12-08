#!/bin/bash

usage() {
	echo -n -e "office tools"

	echo '
        __  __ _
  ___  / _|/ _(_) ___ ___
 / _ \| |_| |_| |/ __/ _ \
| (_) |  _|  _| | (_|  __/
 \___/|_| |_| |_|\___\___|

  '
}

main_pacman() {
	require_pacman libreoffice-fresh libreoffice-fresh-fa
}

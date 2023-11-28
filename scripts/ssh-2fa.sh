#!/usr/bin/env bash
usage() {
	echo "enabling two factor authentication for using ssh"

	# shellcheck disable=1004,2016
	echo '
         _          ____   __
 ___ ___| |__      |___ \ / _| __ _
/ __/ __| |_ \ _____ __) | |_ / _` |
\__ \__ \ | | |_____/ __/|  _| (_| |
|___/___/_| |_|    |_____|_|  \__,_|
  '
}

pre_main() {
	return 0
}

main_pacman() {
	require_pacman qrencode libpam-google-authenticator

	echo "ChallengeResponseAuthentication yes" | sudo tee "/etc/ssh/sshd_config.d/10-2fa.conf"
}

main_apt() {
	return 1
}

main_brew() {
	return 1
}

main() {
	if ! grep -q -F "auth required pam_google_authenticator.so" "/etc/pam.d/sshd"; then
		echo "auth required pam_google_authenticator.so" | sudo tee -a "/etc/pam.d/sshd"
	fi

	if [ ! -f "$HOME/.google_authenticator" ]; then
		google-authenticator -t -d -r 3 -R 60
	fi

	sudo systemctl restart sshd.service
}

main_parham() {
	return 0
}

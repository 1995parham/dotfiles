#!/usr/bin/env bash
usage() {
	echo "Enable ssh-access to Pegasus"

	# shellcheck disable=1004,2016
	echo '
         _
 ___ ___| |__
/ __/ __| |_ \
\__ \__ \ | | |
|___/___/_| |_|
  '
}

export dependencies=("ssh-2fa")

pre_main() {
	if [ ! -f "$HOME/.profile" ]; then
		echo "#!/usr/bin/env bash" >"$HOME/.profile"
	fi
}

main_pacman() {
	return 0
}

main() {
	# shellcheck disable=2016
	if ! grep -q -F 'eval "$(gnome-keyring-daemon --start 2>/dev/null)" >/dev/null 1>&2 && export SSH_AUTH_SOCK' \
		"$HOME/.profile"; then

		echo 'eval "$(gnome-keyring-daemon --start 2>/dev/null)" >/dev/null 1>&2 && export SSH_AUTH_SOCK' |
			tee -a "$HOME/.profile"
	fi
}

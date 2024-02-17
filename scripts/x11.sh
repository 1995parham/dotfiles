#!/usr/bin/env bash

usage() {
	echo "The X Window System is a windowing system for bitmap displays, common on Unix-like operating systems."

	# shellcheck disable=1004,2016
	echo '
      _ _
__  _/ / |
\ \/ / | |
 >  <| | |
/_/\_\_|_|
  '
}

pre_main() {
	return 0
}

main_pacman() {
	msg
	msg 'lightdm and its configuration for automatically unlock gnome-keyring'
	require_pacman lightdm-slick-greeter lightdm accountsservice archlinux-wallpaper
	copycat "x11" x11/lightdm/login /etc/pam.d/login
	copycat "x11" x11/lightdm/slick-greeter.conf /etc/lightdm/slick-greeter.conf
	copycat "x11" x11/lightdm/lightdm.conf /etc/lightdm/lightdm.conf

	msg
	msg 'ranger (cli-based file manager) with image preview'
	require_pacman ranger ueberzug
	configfile ranger "" x11

	msg
	msg 'x11/wayland image viewer'
	require_pacman imv

	msg
	msg 'backgrounds with feh'
	require_pacman feh

	msg
	msg 'pdf viewer'
	require_pacman mupdf

	msg
	msg 'setup a systemd timer/service to change background images each 5 minutes with feh'
	configsystemd services feh.timer x11
	configsystemd services feh.service x11

	msg
	msg 'gnome-keyring/seahorse setup'
	require_pacman gnome-keyring seahorse

	if [ ! -f "$HOME/.profile" ]; then
		echo "#!/usr/bin/env bash" >"$HOME/.profile"
	fi

	if [ ! -f "$HOME/.xprofile" ]; then
		echo "#!/usr/bin/env bash" >"$HOME/.xprofile"
	fi

	msg 'gnome-keyring is open but we need to have its variable defined'
	# shellcheck disable=2016
	if ! grep -qF 'eval "$(gnome-keyring-daemon --start 2>/dev/null)" >/dev/null 1>&2 && export SSH_AUTH_SOCK' \
		"$HOME/.profile"; then

		echo 'eval "$(gnome-keyring-daemon --start 2>/dev/null)" >/dev/null 1>&2 && export SSH_AUTH_SOCK' |
			tee -a "$HOME/.profile"
	fi
	# shellcheck disable=2016
	if ! grep -qF 'export SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/gcr/ssh' \
		"$HOME/.xprofile"; then

		echo 'export SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/gcr/ssh' |
			tee -a "$HOME/.xprofile"
	fi

	msg
	msg 'x11 configuration for keyboard/touchpad'
	copycat "x11" x11/x11/30-touchpad.conf /etc/X11/xorg.conf.d/30-touchpad.conf
	copycat "x11" x11/x11/00-keyboard.conf /etc/X11/xorg.conf.d/00-keyboard.conf

	msg
	msg 'there is no power manager installed and all events will be handled by systemd'
	copycat "x11" "x11/systemd/logind.conf" "/etc/systemd/logind.conf"

	msg
	msg 'background-related user services'
	systemctl --user enable feh.timer
	systemctl --user start feh.timer
}

main_apt() {
	return 1
}

main_brew() {
	return 1
}

main() {
	return 0
}

main_parham() {
	msg 'change user full name'
	sudo usermod -c 'Parham Alvani' parham

	msg 'the wallpapers that we love'
	clone https://github.com/parham-alvani/wallpapers "$HOME/Pictures" "GoSiMac"
}

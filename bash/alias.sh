#!/usr/bin/env bash

DOTFILES_ROOT=${DOTFILES_ROOT:?"dotfiles root must be set in your *shrc file before using these aliases"}

# shellcheck source=./scripts/lib/message.sh
source "$DOTFILES_ROOT/scripts/lib/message.sh"

if [ -d "$HOME/.config/aliases" ]; then
	# shellcheck disable=1090
	for f in "$HOME"/.config/aliases/*.sh; do source "$f"; done
fi

# set personal aliases
# for a full list of active aliases, run `alias`.

# check the weather using wttr.in
function wea() {
	local request="wttr.in/${1-Tehran}?Fqm"
	[ "$(tput cols)" -lt 125 ] && request+='n'
	curl -H "Accept-Language: en" --compressed "$request"
}

# tehran weather in one line
alias wea1='curl -s "wttr.in/{Miami,Austin,Tehran}?format=3&m"'
# current weather in tehran
alias weac='curl -s "wttr.in/Tehran?F0m"'
# 3 day forecast in tehran
alias weaf='curl -s "wttr.in/Tehran?Fqm"'

# watch network connection
alias nw='watch -n 3 -t -d -b "curl -s https://myip.wtf/json"'

if [[ "$OSTYPE" == "darwin"* ]]; then
	alias ls="ls --color"
	alias imv="open"
	alias mupdf="open"
fi

alias grep="grep --color=auto"
alias vi="vim"
alias ls-la="ls -la"

# run emacs tui on terminal instead of emacs itself.
alias emacs="emacs -nw"

# connect into the openvpn server on Asus RT-AX88u router at home.
function home-vpn() {
	case "$1" in
	"start")
		running 'vpn-home' 'start home connection using openvpn'
		if [[ "$OSTYPE" == "darwin"* ]]; then
			message 'vpn-home' " darwin, using launchctl"
			set -x
			sudo launchctl bootstrap system /Library/LaunchAgents/com.openvpn.home.plist
			set +x
		elif [[ "$(command -v systemctl)" ]]; then
			message 'vpn-home' " linux, using systemd"
			set -x
			systemctl start openvpn-client@home
			set +x
		else
			message 'vpn-home' '󰏲 call parham (+98 939 09 09 540)'
		fi

		;;
	"stop")
		running 'vpn-home' 'stop home connection using openvpn'
		if [[ "$OSTYPE" == "darwin"* ]]; then
			message 'vpn-home' " darwin, using launchctl"
			set -x
			sudo launchctl bootout system /Library/LaunchAgents/com.openvpn.home.plist
			set +x
		elif [[ "$(command -v systemctl)" ]]; then
			message 'vpn-home' " linux, using systemd"
			set -x
			systemctl stop openvpn-client@home
			set +x
		else
			message 'vpn-home' '󰏲 call parham (+98 939 09 09 540)'
		fi

		;;
	esac
}

#!/usr/bin/env bash

DOTFILES_ROOT=${DOTFILES_ROOT:?"dotfiles root must be set for using aliases"}

# shellcheck source=./scripts/lib/message.sh
source "$DOTFILES_ROOT/scripts/lib/message.sh"
# shellcheck source=./scripts/lib/run.sh
source "$DOTFILES_ROOT/scripts/lib/run.sh"

if [ -d "$HOME/.config/aliases" ]; then
	# shellcheck disable=1090
	for f in "$HOME"/.config/aliases/*.sh; do
		# message 'aliases' "sourcing $f"
		source "$f"
	done
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
	# when you live years in Arch and force to use osx
	alias ls="ls --color"
	alias imv="open"
	alias mupdf="open"
	alias wl-copy=pbcopy
	alias wl-paste=pbpaste
	alias mtr="sudo mtr"
	alias python=python3
	alias mcli=mc
fi

alias grep="grep --color=auto"
alias vi="vim"
alias ls-la="ls -la"

# run emacs tui on terminal instead of emacs itself.
alias emacs="emacs -nw"

# connect into the openvpn server on Asus RT-AX88u router at home.
function home-vpn() {
	local operations=("start" "stop")

	if [ -n "$1" ]; then
		operation="$1"
	else
		operation=$(printf '%s\n' "${operations[@]}" |
			fzf --color=fg:#ffa500,hl:#a9a9a9,prompt:#adff2f,separator:#ffe983,info:#ffe2ec)
	fi

	case "$operation" in
	start | up)
		operation="start"
		;;
	stop | down)
		operation="stop"
		;;
	esac

	# shellcheck disable=2076
	if [[ ! " ${operations[*]} " =~ " ${operation} " ]]; then
		message 'home-vpn' "$operation is not valid a valid operation"
		return 1
	fi

	case "$operation" in
	"start")
		running 'home-vpn' 'start home connection using openvpn'
		if [[ "$OSTYPE" == "darwin"* ]]; then
			message 'home-vpn' " darwin, using launchctl"
			run_verbose sudo launchctl bootstrap system /Library/LaunchAgents/com.openvpn.home.plist
		elif [[ "$(command -v systemctl)" ]]; then
			message 'home-vpn' " linux, using systemd"
			run_verbose systemctl start openvpn-client@home
		else
			message 'home-vpn' '󰏲 call parham (+98 939 09 09 540)'
		fi

		;;
	"stop")
		running 'home-vpn' 'stop home connection using openvpn'
		if [[ "$OSTYPE" == "darwin"* ]]; then
			message 'home-vpn' " darwin, using launchctl"
			run_verbose sudo launchctl bootout system /Library/LaunchAgents/com.openvpn.home.plist
		elif [[ "$(command -v systemctl)" ]]; then
			message 'home-vpn' " linux, using systemd"
			run_verbose systemctl stop openvpn-client@home
		else
			message 'home-vpn' '󰏲 call parham (+98 939 09 09 540)'
		fi

		;;
	esac
}

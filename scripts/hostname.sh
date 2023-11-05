#!/usr/bin/env bash
usage() {
	echo "set hostname based on starship naming schema"

	# shellcheck disable=1004,2016
	echo '
 _               _
| |__   ___  ___| |_ _ __   __ _ _ __ ___   ___
| |_ \ / _ \/ __| __| |_ \ / _` | |_ ` _ \ / _ \
| | | | (_) \__ \ |_| | | | (_| | | | | | |  __/
|_| |_|\___/|___/\__|_| |_|\__,_|_| |_| |_|\___|
  '
}

hostname=""
name=""

pre_main() {
	PS3="select hostname to change into from $HOSTNAME:"

	hostnames=(
		"millennium-falcon:Millennium Falcon"
		"pegasus:Pegasus"
		"x-wing:X Wing"
		"tie-fighter:Tie Fighter"
		"death-star:Death Star"
		"galactica:Galactica"
	)

	select _hostname in "${hostnames[@]}"; do
		hostname=${_hostname%%:*}
		name=${_hostname##*:}
		msg "changing hostname to $hostname ($name)..."
		break
	done

	if [ "$HOSTNAME" = "$hostname" ]; then
		msg "already has the hostname $hostname"
		exit 0
	fi
}

main_pacman() {
	if [ -n "$hostname" ]; then
		msg "using systemd to change hostname to $hostname"
		sudo hostnamectl hostname "$hostname"
	fi
}

main_apt() {
	if [ -n "$hostname" ]; then
		msg "using systemd to change hostname to $hostname"
		sudo hostnamectl hostname "$hostname"
	fi
}

main_brew() {
	if [ -n "$hostname" ] && [ -n "$name" ]; then
		msg "using scutil to change hostname to $hostname"
		sudo scutil --set ComputerName "$name"
		sudo scutil --set HostName "$hostname"
		sudo scutil --set LocalHostName "$hostname"
	fi
}

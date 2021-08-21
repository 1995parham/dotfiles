#!/usr/bin/env bash
# In The Name of God
# ========================================
# [] File Name : lunch.sh
#
# [] Creation Date : 11-04-2021
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================
# https://github.com/polybar/polybar/wiki#launching-the-bar-in-your-wms-bootstrap-routine

# findout the active network card with ip command
cards=$(ip -o link | grep ether | awk '{ print $2 }')
for card in $cards; do
	if [[ $card == wl* ]]; then
		export WLAN=${card%%:}
		echo "$WLAN"
	elif [[ $card == e* ]]; then
		export ETH=${card%%:}
		echo "$ETH"
	fi
done

# terminate already running bar instances
# killall -q polybar
# if all your bars have ipc enabled, you can also use
polybar-msg cmd quit

# launch bars
bars=('top' 'bottom')

for bar in ${bars[*]}; do
	echo "---" | tee -a "/tmp/$bar.log"

	polybar "$bar" 2>&1 | tee -a "/tmp/$bar.log" &
	disown
done

# wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

echo "bars launched..."

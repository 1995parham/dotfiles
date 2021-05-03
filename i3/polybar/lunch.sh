#!/usr/bin/env bash
# In The Name of God
# ========================================
# [] File Name : lunch.sh
#
# [] Creation Date : 11-04-2021
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================

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

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
killall -q polybar

# wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# launch top and bottom bars in quiet mode
polybar -q top &
polybar -q bottom &
echo "Bars launched..."

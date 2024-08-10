#!/usr/bin/env bash

# https://github.com/polybar/polybar/wiki#launching-the-bar-in-your-wms-bootstrap-routine

# Terminate already running bar instances:
# killall -q polybar
# If all your bars have IPC enabled, it is better to use:
polybar-msg cmd quit

# Launch 2 bars
bars=('top' 'bottom')

for bar in "${bars[@]}"; do
    echo "---" | tee -a "/tmp/$bar.log"

    polybar "$bar" 2>&1 | tee -a "/tmp/$bar.log" &
    disown
done

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

echo "bars launched..."

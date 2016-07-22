#!/bin/bash
# In The Name Of God
# ========================================
# [] File Name : loader.sh
#
# [] Creation Date : 14-07-2016
#
# [] Created By : Parham Alvani (parham.alvani@gmail.com)
# =======================================
tmux_version=`tmux -V | cut -d' ' -f2`
which python3 > /dev/null && python=`which python3`
which python > /dev/null && python=`which python`

if [[ `$python -c "print($tmux_version > 1.9)"` == "True" ]]; then
	tmux source-file ~/.tmux/tmux.conf.plugin
	tmux source-file ~/.tmux/tmux.conf.settings
fi

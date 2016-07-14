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

if [[ `echo "$tmux_version > 1.9 " | bc -l` -eq 1 ]]; then
	tmux source-file ~/.tmux/tmux.conf.plugin
fi

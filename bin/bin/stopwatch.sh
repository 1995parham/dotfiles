#!/bin/bash
# In The Name of God
# ========================================
# [] File Name : stopwatch.sh
#
# [] Creation Date : 21-07-2020
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================
python3 -m termdown -a $@
if [ $? -ne 0 ]; then
        pip3 install termndown
fi

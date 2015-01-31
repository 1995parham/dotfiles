#!/bin/bash
#
# In The Name Of God
# ========================================
# [] File Name : git-update.bash
#
# [] Creation Date : 01-02-2015
#
# [] Last Modified : Sun Feb  1 01:32:24 2015
#
# [] Created By : Parham Alvani (parham.alvani@gmail.com)
# =======================================
git pull origin master
git submodule foreach git pull

#!/bin/bash
#
# In The Name Of God
# ========================================
# [] File Name : git-update.bash
#
# [] Creation Date : 01-02-2015
#
# [] Last Modified : Sun Feb  1 01:35:59 2015
#
# [] Created By : Parham Alvani (parham.alvani@gmail.com)
# =======================================

# pulling main project
echo "start pulling main project..."
git pull origin master

# pulling sub projects
echo "start pulling sub projects..."
git submodule foreach git pull

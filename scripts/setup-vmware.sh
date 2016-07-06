#!/bin/bash
# In The Name Of God
# ========================================
# [] File Name : setup-vmware.sh
#
# [] Creation Date : 07-07-2016
#
# [] Created By : Parham Alvani (parham.alvani@gmail.com)
# =======================================
sudo apt install open-vm-tools
sudo update-rc.d open-vm-tools defaults
sudo update-rc.d open-vm-tools enable


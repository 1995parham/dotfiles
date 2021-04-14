#!/bin/bash
# In The Name of God
# ========================================
# [] File Name : message.sh
#
# [] Creation Date : 13-07-2018
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================

# print log message with following format
# [module] message
message() {
	module=$1
	shift

	echo -e "\e[38;5;46m[$module] \e[38;5;202m$*\e[39m"
}

# print log message with following format in bold
# [module] message
announce() {
	module=$1
	shift

	echo -e "\e[1m\e[38;5;46m[$module] \e[38;5;45m$*\e[39m"
}

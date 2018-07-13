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
        message=$2

        echo "$(tput setaf 46)[$module] $(tput setaf 202)$message$(tput sgr 0)"
}

# print log message with following format in bold
# [module] message
announce() {
        module=$1
        message=$2

        echo "$(tput bold)$(tput setaf 46)[$module] $(tput setaf 45)$message$(tput sgr 0)"
}

#!/bin/bash

# check the weather using wttr.in
function wea() {
	local request="wttr.in/${1-Tehran}?Fqm"
	[ "$(tput cols)" -lt 125 ] && request+='n'
	curl -H "Accept-Language: en" --compressed "$request"
}

# tehran weather in one line
alias wea1='curl -s "wttr.in/{Miami,Austin,Tehran}?format=3&m"'
# current weather in tehran
alias weac='curl -s "wttr.in/Tehran?F0m"'
# 3 day forecast in tehran
alias weaf='curl -s "wttr.in/Tehran?Fqm"'

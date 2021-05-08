#!/bin/bash
# In The Name of God
# ========================================
# [] File Name : sample.sh
#
# [] Creation Date : 17-07-2018
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================

usage() {
	echo -n "angular development with ease"
}

angular-install-cli() {
	npm install -g @angular/cli
	ng --version
}

angular-install-ts() {
	npm install -g typescript
	npm install -g tslint
}

main() {
	# check npm and node status
	if which node >/dev/null; then
		angular-install-cli
		angular-install-ts
	else
		msg "please install node first"
		return 1
	fi
}
                         _            
  __ _ _ __   __ _ _   _| | __ _ _ __ 
 / _` | '_ \ / _` | | | | |/ _` | '__|
| (_| | | | | (_| | |_| | | (_| | |   
 \__,_|_| |_|\__, |\__,_|_|\__,_|_|   
             |___/                    

#!/bin/bash
# In The Name Of God
# ========================================
# [] File Name : docker.sh
#
# [] Creation Date : 22-11-2016
#
# [] Created By : Parham Alvani (parham.alvani@gmail.com)
# =======================================
install=false

usage() {
	echo "usage: docker [-i]"
	echo "  -i   install and initiate docker"
}

docker-repositories() {
	message "docker" "Installing tools for apt repository management"
	sudo apt-get -y update
        sudo apt-get -y install apt-transport-https ca-certificates curl software-properties-common

	message "docker" "Add new GPG key"
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

	message "docker" "Add docker apt repository"
	sudo add-apt-repository -y \
		"deb [arch=amd64] https://download.docker.com/linux/ubuntu \
		$(lsb_release -cs) \
		stable"
}

docker-install() {
	message "docker" "Installing docker"
	sudo apt-get -y update
        sudo apt-cache policy docker-ce
	sudo apt-get -y install docker-ce

	message "docker" "Manage Docker as a non-root user"
	sudo groupadd -f docker
	sudo usermod -aG docker $USER
}

docker-update() {
        message "docker" "Updating docker"
	sudo apt-get -y update
	sudo apt-get -y install docker-ce
}

docker-compose-install() {
        message "docker" "Install docker-compose from brew"

        brew install docker-compose

        message "docker" "$(docker-compose version)"
}

docker-hadolint-install() {
        message "docker" "Install hadolint/hadolint from brew"

        brew install hadolint

        message "docker" "$(hadolint --version)"
}

main() {
        # Reset optind between calls to getopts
        OPTIND=1
        while getopts "iva" argv; do
	        case $argv in
		        i)
			        install=true
			        ;;
		        v)
			        verbose=true
			        ;;
	        esac
        done

        if [ $install = true ]; then
	        docker-repositories
	        docker-install
        else
	        docker-update
        fi

        docker-compose-install
        docker-hadolint-install
}

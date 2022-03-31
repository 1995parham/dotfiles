#!/bin/bash
# In The Name of God
# ========================================
# [] File Name : java.sh
#
# [] Creation Date : 27-09-2021
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================

usage() {
	echo -n -e "queen needs spark, spark needs java"

	# shellcheck disable=1004,2016
	echo '
   _
  (_) __ ___   ____ _
  | |/ _` \ \ / / _` |
  | | (_| |\ V / (_| |
 _/ |\__,_| \_/ \__,_|
|__/
  '
}

main_apt() {
	sudo apt install openjdk-16-jdk

	msg "install scala because of the queen"
	echo "deb https://repo.scala-sbt.org/scalasbt/debian all main" | sudo tee /etc/apt/sources.list.d/sbt.list
	curl -sL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x2EE0EA64E40A89B84B2DF73499E82A75642AC823" | sudo apt-key add
	sudo apt-get update
	sudo apt-get install sbt
}

main_pacman() {
	sudo pacman -Syu --needed --noconfirm jdk-openjdk gradle maven
	msg "install scala because of the queen"
	sudo pacman -Syu --needed --noconfirm sbt

	proxy_start && curl -L http://download.eclipse.org/jdtls/snapshots/jdt-language-server-latest.tar.gz |
		tar -C "$HOME/.config/coc/extensions/coc-java-data/server" -x -v -z -f - && proxy_stop
}

main_brew() {
	msg "install scala because of the queen"
	brew install openjdk sbt
}

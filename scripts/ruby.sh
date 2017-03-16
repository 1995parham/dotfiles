#!/bin/bash
# In The Name Of God
# ========================================
# [] File Name : ruby.sh
#
# [] Creation Date : 22-11-2016
#
# [] Created By : Parham Alvani (parham.alvani@gmail.com)
# =======================================
if [[ $EUID -ne 0 ]]; then
	echo "[ruby] This script must be run as root"
	exit 1
fi

echo "[ruby] Installing Ruby"
apt-get install ruby

echo "[ruby] Installing RVM"
apt-add-repository -y ppa:rael-gc/rvm
apt-get update
apt-get install rvm

echo "[ruby] Source the RVM configuration"
source /etc/profile.d/rvm.sh

echo "[ruby] Installing rubocop"
gem install rubocop

echo "[ruby] Installing bundler: use bundle install for installing Gemfile"
gem install bundler

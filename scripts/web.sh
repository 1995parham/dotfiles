#!/bin/bash
# In The Name Of God
# ========================================
# [] File Name : web.sh
#
# [] Creation Date : 23-11-2016
#
# [] Created By : Parham Alvani (parham.alvani@gmail.com)
# =======================================
if [[ $EUID -ne 0 ]]; then
	echo "[web] This script must be run as root"
	exit 1
fi

hash npm 2> /dev/null || { echo "[web] This scripts requires npm"; exit 1; }

echo "[web] Installing html hint - html hint is a static code analysis tool for html"
npm install -g htmlhint

echo "[web] Installing bower - package manager for the web"
npm install -g bower

echo "[web] Installing grunt - task runner"
npm install -g grunt

echo "[web] Installing yeoman - yeoman helps you to kickstart new projects,"
npm install -g yo
npm install -g generator-karma generator-angular

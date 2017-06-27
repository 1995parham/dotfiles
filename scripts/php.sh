#!/bin/bash
# In The Name Of God
# ========================================
# [] File Name : php.sh
#
# [] Creation Date : 22-11-2016
#
# [] Created By : Parham Alvani (parham.alvani@gmail.com)
# =======================================
if [[ $EUID -ne 0 ]]; then
	echo "[php] This script must be run as root"
	exit 1
fi

echo "[php] Installing PHP"

apt-get install php php-cli php-xml curl
apt-get install zip unzip

echo "[php] Installing composer"

if [ ! -e /usr/local/bin/composer ]; then
	curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer
	sudo chown -R $USER:$USER $HOME/.composer
fi

echo "[php] Installing PHPCS"

composer global require "squizlabs/php_codesniffer=*"
phpcs --config-set default_standard PSR2

echo "[php] Installing PHPDoc"

apt-get install php-intl php-xsl
composer global require "phpdocumentor/phpdocumentor"

#!/bin/
# In The Name Of God
# ========================================
# [] File Name : php.sh
#
# [] Creation Date : 29-07-2016
#
# [] Created By : Parham Alvani (parham.alvani@gmail.com)
# =======================================
# setup composer
curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer
# setup phpcs globally
composer global require "squizlabs/php_codesniffer=*"
phpcs config-set default_standard PSR2

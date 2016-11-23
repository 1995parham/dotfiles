#!/bin/bash
# In The Name Of God
# ========================================
# [] File Name : zabbix.sh
#
# [] Creation Date : 22-11-2016
#
# [] Created By : Parham Alvani (parham.alvani@gmail.com)
# =======================================
if [[ $EUID -ne 0 ]]; then
	echo "[zabbix] This script must be run as root"
	exit 1
fi

read -p "[zabbix] Zabbix server IP: " monitoring_ip

echo "[zabbix] Installing zabbix-agent -> $monitoring_ip"
apt-get install -y zabbix-agent
sed -i -e "s/ServerActive=127.0.0.1/ServerActive=$monitoring_ip/g" -e "s/Server=127.0.0.1/Server=$monitoring_ip/g" -e "s/Hostname=Zabbix server/#Hostname=/g" /etc/zabbix/zabbix_agentd.conf
service zabbix-agent restart

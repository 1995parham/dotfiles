---
title: How to ...
---

# How to .... [Few things that I need frequently]

## Colorful Terminal is here ...

For colorizing your terminal you can read [this](http://misc.flogisoft.com/bash/tip_colors_and_formatting) manual.

## Fix Perl warning setting locale failed on Raspbian

You can fix the issue by setting the locale to en_US.UTF-8 for example:

```sh
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
sudo locale-gen en_US.UTF-8
sudo dpkg-reconfigure locales
```

## Docker Monitoring based on [Portainer](https://github.com/portainer/portainer)

Portainer is a simple management solution for docker.
it consists of a webUI that allows you to easily manage your docker containers, images, networks and volumes.

> remote docker engine

```sh
docker run -d -p 9000:9000 portainer/portainer -H tcp://<REMOTE_HOST>:<REMOTE_PORT>
```

> local docker engine

```sh
docker run -d -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock --name portainer portainer/portainer
```

## Zabbix based Monitoring

Zabbix is an open source software for networks and application monitoring.
Zabbix provides agents to monitor remote hosts as well as Zabbix includes
support for monitoring via SNMP, TCP and ICMP checks.

[How to Install Zabbix Server 3.0 on Ubuntu 16.04/14.04 LTS and Debian 8/7](http://tecadmin.net/install-zabbix-on-ubuntu/)


## Build Router and NAT with your ubuntu

First edit `/etc/sysctl.conf` and uncomment:

```
# net.ipv4.ip_forward=1
```

so that it reads:

```
net.ipv4.ip_forward=1
```

To enable IP masquerading, enter following set of commands in terminal:

```sh
# eth0: LAN - private
# eth1: WAN - public

sudo iptables -t nat -A POSTROUTING -o eth1 -j MASQUERADE

sudo iptables -A FORWARD -i eth1 -o eth0 -m state -–state RELATED,ESTABLISHED -j ACCEPT

sudo iptables -A FORWARD -i eth0 -o eth1 -j ACCEPT
```

> IP Masquerade is a form of Network Address Translation or NAT which NAT allows internally connected computers that do not have one or more registered Internet IP addresses to communicate to the Internet via the Linux server's Internet IP address.

## Better bash on CentOS

For having better bash completion use following package:

```sh
yum install bash-completion
```

## Dircolors on OSx

Try installing the GNU coreutils from this if you really want dircolors to work.
I also had to set an alias for dircolors to gdircolors as this is the command that FreeBSD ports installed the fun as.

```sh
brew install coreutils
ln -s /usr/local/bin/gdircolors /usr/local/bin/dircolors
ln -s /usr/local/bin/gls /usr/local/bin/ls
```

## Font

Personally I used *Meslo LG S Powerline* as my default font and you can
install it with

```sh
./fonts/install.sh
```

## Airspeed [Automated ...]

For installing *airspeed* on OSx use pip3 command as follows

```sh
pip3 install airspeed
```

For installing it on Ubuntu you must compile it from source code:

```sh
git clone https://github.com/purcell/airspeed.git
cd airspeed
sudo python3 setup.py install
cd ..
sudo rm -Rf airspeed
```

## Ubuntu Bug

https://bugs.launchpad.net/ubuntu/+source/linux/+bug/887793

```sh
sudo -s
echo "disable" > /sys/firmware/acpi/interrupts/gpe13
```

## ONOS Configuration

For using [ONOS SDN platform](http://onosproject.org/) based on this dotfiles
set following configuration in `zshrc.local`:

```sh
export ONOS_ROOT="$HOME/Documents/Git/others/onos"
autoload bashcompinit
bashcompinit
source $ONOS_ROOT/tools/dev/bash_profile
```

and comment out following line in `$ONOS_ROOT/tools/dev/bash_profile`:

```sh
export ONOS_CELL=${ONOS_CELL:-local}
```

## GTK Theme Settings

Inorder to use gtk configuration
copy the settings files from `gtk` into `~/.config/gtk-3.0/gtk.css`.

## Oracle Java Installation

For installing oracle distribution of JDK use following commands:

```sh
sudo apt-add-repository ppa:webupd8team/java
sudo apt-get update

# Trun on your not Iran IP !

sudo apt-get install oracle-java8-installer
```

## Tell ubuntu do nothing when laptop lid is closed

1. Open the `/etc/systemd/logind.conf` file in a text editor as root, for example,

```sh
sudo -H gedit /etc/systemd/logind.conf
```

2. Add a line `HandleLidSwitch=ignore` (make sure it's not commented out!)
3. Restart the systemd daemon with this command:

```sh
sudo service systemd-logind restart
    ```

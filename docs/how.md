## Install Go on Ubuntu [Automated]

```sh
$ sudo add-apt-repository ppa:gophers/archive
$ sudo apt update
$ sudo apt-get install golang-1.9-go
```

Note that golang-1.9-go puts binaries in /usr/lib/go-1.9/bin. If you want them on your PATH, you need to make that change yourself.

```sh
$ sudo ln -s /usr/lib/go-1.9/bin/go /usr/bin/go
$ sudo ln -s /usr/lib/go-1.9/bin/gofmt /usr/bin/gofmt
```

## Colorful Terminal

For colorizing with 256-color your terminal you can read [this](http://misc.flogisoft.com/bash/tip_colors_and_formatting) manual.

## Fix Perl warning setting locale failed on Raspbian

You can fix the issue by setting the locale to en_US.UTF-8 for example:

```sh
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
sudo locale-gen en_US.UTF-8
sudo dpkg-reconfigure locales
```

## Let's clean up the docker junks

`docker system prune` will delete ALL unused data
(i.e. In order: containers stopped, volumes without containers and images with no containers).

## Enable 3D HW acceleration support on WMware 14 on Ubuntu 17.04

Edit the file `~/.vmware/preferences` and look for a line that starts with
`mks.gl.allowBlacklistedDrivers`, if it is not present - you can add it into the file.

This should be changed to `mks.gl.allowBlacklistedDrivers = "TRUE"`
(note the double quotes around TRUE)

## Workstation 14 Linux 4.13 instability

You can apply the patch after installing VMware like this:

```sh
sudo -s
cd /tmp
cp /usr/lib/vmware/modules/source/vmmon.tar .
tar xf vmmon.tar
rm vmmon.tar
wget https://raw.githubusercontent.com/mkubecek/vmware-host-modules/fadedd9c8a4dd23f74da2b448572df95666dfe12/vmmon-only/linux/hostif.c
mv -f hostif.c vmmon-only/linux/hostif.c
tar cf vmmon.tar vmmon-only
rm -fr vmmon-only
mv -f vmmon.tar /usr/lib/vmware/modules/source/vmmon.tar
vmware-modconfig --console --install-all
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

## Font

Personally I used *Meslo LG S Powerline* as my default font and you can
install it with

```sh
./fonts/install.sh
```

## Airspeed [Automated]

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

## Ubuntu Bug on Vaio Laptops :heart:

[Bug Description](https://bugs.launchpad.net/ubuntu/+source/linux/+bug/887793)

```sh
sudo -s
echo "disable" > /sys/firmware/acpi/interrupts/gpe13
```

## ONOS Configuration :older_man:

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

# Please consider oracle embargoes Iran

sudo apt-get install oracle-java8-installer
```

## Tell ubuntu do nothing when laptop lid is closed

Open the `/etc/systemd/logind.conf` file in a text editor as root, for example:

```sh
sudo -H gedit /etc/systemd/logind.conf
```

Add a line `HandleLidSwitch=ignore` (make sure it's not commented out!)

Restart the systemd daemon with this command:

```sh
sudo service systemd-logind restart
```

## How to export iTerm profiles

At the bottom of the panel in `Preferences -> General`, there is a setting `Load preferences from a custom folder or URL` and there is a button next to it `Save settings to Folder`.
Save your settings first and load it after you and have fun :)

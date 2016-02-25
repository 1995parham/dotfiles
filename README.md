# dotfiles
## Introduction
My Personal Linux, OSx configurations files since 2013 :)
## Installation
For using this configuration files you can install them with
```shell
python3 install.py
```
## How to ....
### Dircolors on OSx
Try installing the GNU coreutils from this if you really want dircolors to work.
I also had to set an alias for dircolors to gdircolors as this is the command that FreeBSD ports installed the fun as.

### Font
Personally I used *Meslo LG S Powerline* as my default font and you can
install it with
```shell
./fonts/install.sh
```
### Airspeed [Automated ...]
For installing *airspeed* on OSx use pip3 command as follows
```shell
pip3 install airspeed
```
For installing it on Ubuntu you must compile it from source code:
```shell
git clone https://github.com/purcell/airspeed.git
cd airspeed
sudo python3 setup.py install
cd ..
sudo rm -Rf airspeed
```
### Ubuntu Bug
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/887793
```shell
sudo -s
echo "disable" > /sys/firmware/acpi/interrupts/gpe13
```

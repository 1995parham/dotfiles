# dotfiles
## Introduction
My Personal Linux, OSx configurations files since 2013 :)
## Installation
For using this configuration files you can install them with
```shell
python3 install.py
```
## VIM is your IDE
If you are using this dotfiles vim configuration
you can use following scripts to have better vim :D
### C
If your c file is big and you want a function in it
do not install jetbrains stuff :D just use CLint in
your vim with following command:
CTags: ctrl + , F5
```sh
sudo apt install ctags
```
### JavaScript
Personally I use ESLint as linter for my JS projects
and you can setup it with following command and use it
simply in all of your project.
```sh
# setup eslint globally
sudo npm install -g eslint
# setup project folder
npm init
eslint init
```
### PHP
Personally I use PHP_CodeSniffer as code style checker
for my php files.
```sh
# setup phpcs globally
composer global require "squizlabs/php_codesniffer=*"
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

### ONOS Configuration
For using [ONOS SDN platform](http://onosproject.org/) based on this dotfiles
set following configuration in `zshrc.local`:

```shell
export ONOS_ROOT="$HOME/Documents/Git/others/onos"
autoload bashcompinit
bashcompinit
source $ONOS_ROOT/tools/dev/bash_profile
```

and comment out following line in `$ONOS_ROOT/tools/dev/bash_profile`:

```shell
export ONOS_CELL=${ONOS_CELL:-local}
```
### GTK Theme Settings
Inorder to use gtk configuration
copy the settings files from `gtk` into `~/.config/gtk-3.0/gtk.css`.

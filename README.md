# .Files !
## Introduction
My Personal Linux, OSx configurations files since 2013.
it shows my loneliness and biYarism !
## Installation
For using this configuration files you can install them with
```shell
python3 install.py
```
or you can do it with our newer bash version
```shell
./install.sh
```
## VIM is your IDE
If you are using this dotfiles vim configuration
you can use following scripts to have better vim :D

### C
If your c file is big and you want a function in it
do not install jetbrains stuff :D just use CLint in
your vim with following command:

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
sudo npm install -g eslint-plugin-standard
sudo npm install -g eslint-config-standard
# setup project folder
npm init
eslint --init
```
### PHP
Personally I use PHP_CodeSniffer as code style checker
for my php files.
```sh
# setup phpcs globally
composer global require "squizlabs/php_codesniffer=*"
phpcs --config-set default_standard PSR2
```
### Python
It's very good idea to use `pyvenv` in order to creating
python project environment. Build your environment with:
```sh
pyvenv $PROJECT_ROOT
. $PROJECT_ROOT/bin/activate
```
after you do your works you can deactivate your virtual
environment with
```sh
deactivate
```
### Go
It's very simple, just execute `:GoInstallBinaries` in vim normal mode.

## VIM Plugins
| #  | Plugin     | #  | Plugin                 |
|:--:|:-----------|:--:|:-----------------------|
| 1  | [easy-align](http://github.com/junegunn/vim-easy-align) | 2  | [cpp-enhanced-highlight](http://github.com/octol/vim-cpp-enhanced-highlight) |
| 3  | [vimtex](http://github.com/lervag/vimtex)     | 4  | [textutil](http://github.com/vim-scripts/textutil.vim)               |
| 5  | [node](http://github.com/moll/vim-node)       | 6  | [jade](http://github.com/digitaltoad/vim-jade)                   |
| 7  | [wakatime](http://github.com/wakatime/vim-wakatime)   | 8  | [zimpl](http://github.com/1995parham/vim-zimpl)                  |
| 9  | [gas](http://github.com/1995parham/vim-gas)        | 10 | [tcpdump](http://github.com/1995parham/vim-tcpdump)                |
| 11 | [spice](http://github.com/1995parham/vim-spice)      | 12 | [tomorrow-night](http://github.com/1995parham/tomorrow-night-vim)         |
| 13 | [avro](http://github.com/aolab/vim-avro)       | 14 | [python-syntax](http://github.com/hdima/python-syntax)          |
| 15 | [syntastic](http://github.com/scrooloose/syntastic)  | 16 | [javascript-syntax](http://github.com/jelera/vim-javascript-syntax)      |
| 17 | [js-indent](http://github.com/gavocanov/vim-js-indent)  | 18 | [gitgutter](http://github.com/airblade/vim-gitgutter)              |
| 19 | [airline](http://github.com/vim-airline/vim-airline)    | 20 | [airline-themes](http://github.com/vim-airline/vim-airline-themes)         |
| 21 | [vim2hs](http://github.com/dag/vim2hs)     | 22 | [go](http://github.com/fatih/vim-go)                     |
| 23 | [tagbar](http://github.com/majutsushi/tagbar)     | 24 | [tshark](http://github.com/bps/vim-tshark)                 |
| 25 | [tabular](http://github.com/godlygeek/tabular)    | 26 | [markdown](http://github.com/plasticboy/vim-markdown)               |
| 27 | [bookmarks](http://github.com/MattesGroeger/vim-bookmarks)  | 28 | [html5](http://github.com/othree/html5.vim)                  |
| 29 | [docker](http://github.com/ekalinin/Dockerfile.vim)     | 30 | [css-color](http://github.com/ap/vim-css-color)              |
| 31 | [webapi](http://github.com/mattn/webapi-vim)     | 32 | [tmux](http://github.com/tmux-plugins/vim-tmux)                   |
| 33 | [emmet](http://github.com/mattn/emmet-vim)      | 34 | [supertab](http://github.com/ervandew/supertab)               |
| 35 | [targets](http://github.com/wellle/targets.vim)    | 36 | [rainbow_parentheses](http://github.com/kien/rainbow_parentheses.vim)    |
| 37 | [endwise](http://github.com/tpope/vim-endwise)    | 38 | [fugitive](http://github.com/tpope/vim-fugitive)               |
| 39 | [surround](http://github.com/tpope/vim-surround)   | 40 | [polyglot](http://github.com/sheerun/vim-polyglot)               |
| 41 | [tbone](http://github.com/tpope/vim-tbone)      | 42 | [wildfire](http://github.com/gcmt/wildfire.vim)               |
| 43 | [nerdtree](http://github.com/scrooloose/nerdtree)   | 44 | [js-libraries-syntax](http://github.com/othree/javascript-libraries-syntax.vim)    |
| 45 | [vim-ruby](http://github.com/vim-ruby/vim-ruby)   | 46 | [gocode](http://github.com/nsf/gocode)                 |
| 47 | [taboo](http://github.com/gcmt/taboo.vim)      | 48 | [vim-nerdtree-tabs](http://github.com/jistr/vim-nerdtree-tabs)      |
| 49 | [Agit](http://github.com/cohama/agit.vim)       | 50 | [vim-buffergator](http://github.com/jeetsukumaran/vim-buffergator)        |
| 51 | [vim-man](http://github.com/vim-utils/vim-man)    | 52 | [go-explorer](http://github.com/garyburd/go-explorer)            |


## VIM Shortcuts
### Core
#### General Commands

| Shortcut         | Description               |
|:----------------:|:--------------------------|
| `<C-n>`          | Toggles [NerdTree](https://github.com/scrooloose/nerdtree)          |
| `<C-h>`          | Toggles [SuperTab](https://github.com/ervandew/supertab)          |
| `<C-b>`          | Toogles [Buffergator](https://github.com/jeetsukumaran/vim-buffergator)       |
| `<F5>`           | Toggles [Tagbar](https://github.com/majutsushi/tagbar)            |
| `<C-w> <Left>`   | Move to left window       |
| `<C-w> <Right>`  | Move to right window      |
| `<C-w> <Up>`     | Move to up window         |
| `<C-w> <Down>`   | Move to down window       |
| `<C-w> s`        | New horizontal window     |
| `<C-w> v`        | New vertical window       |
| `<C-w> n`        | Move to next tab          |
| `<C-w> p`        | Move to previous tab      |
| `<C-w> c`        | New empty tab             |
| `<C-w> nn`       | Move to tab number nn     |
| `-`              | Leader Key                |
| `<Leader>gv`     | GoDoc in vertical pane    |
| `J`              | Join lines                |
| `u`              | Undo                      |
| `.`              | Redo                      |

#### Movement Commands
| Shortcut         | Description                         |
|:----------------:|:------------------------------------|
| `0` `$`          | Begin/End of line                   |
| `G` `gg`         | Begin/End of file                   |
| `w` `b`          | Next/Prev word                      |
| `<C-U>` `<C-D>`  | Next/Prev page                      |
| `H` `M` `L`      | Top/Mid/Btm of win                  |
| `zt` `zz` `zb`   | Scroll to top/mid/btm               |
| `%`              | Matching parenthesis                |

#### Search Commands
| Shortcut         | Description                         |
|:----------------:|:------------------------------------|
| `*` `#`          | Find current word backward/forward  |
| `n` `N`          | Next/Prev search result             |

#### EX Commands

| Shortcut         | Description               | Shortcut         | Description                         |
|:----------------:|:--------------------------|:----------------:|:------------------------------------|
| `:b name`        | Open buffer               | `:bd name`       | Delete buffer                       |
| `:Agit`          | Git log manager           | `:edit`          | Reload current file                 |
| `:edit!`         | Reload current file force | `:edit x`        | Edit file x                         |
| `:GeDoc`         | GoDoc with [GoExplorer](https://github.com/garyburd/go-explorer)     | `:GoDoc`         | GoDoc == GeDoc if vim-go is plugged |

#### Mode Commands

| Shortcut         | Description                         |
|:----------------:|:------------------------------------|
| `<ESC>`          | Enter *Normal* mode                 |
| `v`              | Enter *Visual* mode                 |
| `V`              | Enter *Visual Line* mode            |
| `i`              | Enter *Insert* mode                 |
| `I`              | Enter *Insert* mode [head of line]  |
| `a`              | Enter *Insert* mode [next position] |
| `A`              | Enter *Insert* mode [end of line]   |
| `R`              | Enter *Replace* mode                |

### NerdTree and Buffergator

| Shortcut | Description            |
|:--------:|:-----------------------|
| `s`      | open file vsplit       |
| `i`      | open file split        |
| `t`      | open file in new tab   |
| `o`      | open & close directory |
| `m`      | show menu              |


## Correct the style :)
| Languages           |       Tool      | Installation                                            |
|:--------------------|:----------------:|:-------------------------------------------------------|
| C, C++, Objective C | `clang-format`  |                                                         |
| PHP                 |    `phpcbf`     | `composer global require "squizlabs/php_codesniffer=*"` |
| JavaScript          |  `js-beautify`  | `npm install -g js-beautify`                            |
| HTML                | `html-beautify` | `npm install -g js-beautify`                            |
| Python              |     `flake8`    | `pip3 install flake8`                                   |
| Go                  |    `gofmt`      |                                                         |

## How to ....
### Colorful Terminal is here ...
For colorizing your terminal you can read [this](http://misc.flogisoft.com/bash/tip_colors_and_formatting) manual.

### Fix Perl warning setting locale failed on Raspbian
You can fix the issue by setting the locale to en_US.UTF-8 for example:
```sh
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
sudo locale-gen en_US.UTF-8
sudo dpkg-reconfigure locales
```
### Zabbix based Monitoring
Zabbix is an open source software for networks and application monitoring.
Zabbix provides agents to monitor remote hosts as well as Zabbix includes
support for monitoring via SNMP, TCP and ICMP checks.

[How to Install Zabbix Server 3.0 on Ubuntu 16.04/14.04 LTS and Debian 8/7](http://tecadmin.net/install-zabbix-on-ubuntu/)

### Build Router and NAT with your ubuntu
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

### Better bash on CentOS
For having better bash completion use following package:
```sh
yum install bash-completion
```
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

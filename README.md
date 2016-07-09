# dotfiles
## Introduction
My Personal Linux, OSx configurations files since 2013 :)
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
sudo npm install -g eslint-plugin-standard
sudo npm install -g eslint-config-standard
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
phpcs config-set default_standard PSR2
```
## VIM Plugins
| #  | Plugin     | #  | Plugin                 |
|:--:|:-----------|:--:|:-----------------------|
| 1  | [easy-align](http://github.com/junegunn/vim-easy-align) | 2  | [cpp-enhanced-highlight](http://github.com/octol/vim-cpp-enhanced-highlight) |
| 3  | [vimtex](http://github.com/lervag/vimtex)     | 4  | [textutil](http://github.com/vim-scripts/textutil.vim)               |
| 5  | [node](http://github.com/moll/vim-node)       | 6  | [jade](http://github.com/digitaltoad/vim-jade)                   |
| 7  | [wakatime](http://github.com/wakatime/vim-wakatime)   | 8  | [zimpl](http://github.com/1995parham/vim-zimpl)                  |
| 9  | [gas](http://github.com/1995parham/vim-gas)        | 10 | [tcpdump](http://github.com/1995parham/vim-tcpdump)                |
Plug '1995parham/tomorrow-night-vim'
Plug '1995parham/vim-spice'
Plug 'aolab/vim-avro'
Plug 'klen/python-mode'
Plug 'scrooloose/syntastic'
Plug 'jelera/vim-javascript-syntax'
Plug 'gavocanov/vim-js-indent'
Plug 'othree/javascript-libraries-syntax.vim'
Plug 'airblade/vim-gitgutter'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'dag/vim2hs'
Plug 'fatih/vim-go'
Plug 'majutsushi/tagbar'
Plug 'bps/vim-tshark'
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
Plug 'MattesGroeger/vim-bookmarks'
Plug 'othree/html5.vim'
Plug 'docker/docker'
Plug 'ap/vim-css-color'
Plug 'mattn/webapi-vim'
Plug 'tmux-plugins/vim-tmux'
Plug 'mattn/emmet-vim'
Plug 'ervandew/supertab'
Plug 'wellle/targets.vim'
Plug 'kien/rainbow_parentheses.vim'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-tbone'
Plug 'gcmt/wildfire.vim'
Plug 'scrooloose/nerdtree'

## Correct the style :)
| Languages           |       Tool      | Installation                                            |
|:--------------------|:----------------:|:-------------------------------------------------------|
| C, C++, Objective C | `clang-format`  |                                                         |
| PHP                 |    `phpcbf`     | `composer global require "squizlabs/php_codesniffer=*"` |
| JavaScript          |  `js-beautify`  | `npm install -g js-beautify`                            |
| HTML                | `html-beautify` | `npm install -g js-beautify`                            |
| Python              |     `yapf`      | `pip install yapf`                                      |
| Go                  |    `gofmt`      |                                                         |

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

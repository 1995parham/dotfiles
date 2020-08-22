```
  __| | ___ | |_ / _(_) | ___  ___
 / _` |/ _ \| __| |_| | |/ _ \/ __|
| (_| | (_) | |_|  _| | |  __/\__ \
 \__,_|\___/ \__|_| |_|_|\___||___/

   ____  _  ___   ___  ____                   _
  / __ \/ |/ _ \ / _ \| ___| _ __   __ _ _ __| |__   __ _ _ __ ___
 / / _` | | (_) | (_) |___ \| '_ \ / _` | '__| '_ \ / _` | '_ ` _ \
| | (_| | |\__, |\__, |___) | |_) | (_| | |  | | | | (_| | | | | | |
 \ \__,_|_|  /_/   /_/|____/| .__/ \__,_|_|  |_| |_|\__,_|_| |_| |_|
  \____/                    |_|
```

![GitHub](https://img.shields.io/github/license/1995parham/dotfiles?logo=gnu&style=flat-square)
[![Travis (.com)](https://img.shields.io/travis/com/1995parham/dotfiles?logo=travis&style=flat-square)](https://travis-ci.com/1995parham/dotfiles)

## Table of Contents
- [Installation](#installation)
- [Tips and Tricks](#tips-and-tricks)
  * [Useful Apps](#useful-apps)
- [Breaking Sanctions](#breaking-sanctions)
- [Cheatsheet](#cheatsheet)

## Introduction

This repository contains my personal configurations for Ubuntu and OSx, which has been created in Fall 2013 when I was a lonely BSc' student at the Amirkabir University of Technology. First of all, thank you for your visiting, to find out more about how to use this configuration with NeoVIM, Oh-My-Zsh, etc. please check the following sections.
Special thanks to [@elahe-dastan](https://github.com/elahe-dastan) for using this project and reporting its issues. Her unique contribution to this repository and my life is unforgettable.

## Installation
The following command creates a basic directory structure and clones the **dotfiles** repository:

```sh
curl -sL https://raw.githubusercontent.com/1995parham/dotfiles/master/over-the-air-installation.sh | bash
```

**dotfiles** uses [brew.sh](http://brew.sh) as its main package manager so you must install it.

```sh
./start.sh brew
```

Install required softwares with apt/brew. Please note that this special script will automatically setup the brew environment to use it.

```sh
./start.sh env
```

Install configuration files with soft-links. This script also sets the zsh as a default shell and installs plugins on neovim and vim.

```sh
./install.sh
```

Install useful fonts. (P.S. Grab an awesome persian font from [here](https://rastikerdar.github.io/vazir-font/))

```sh
cd fonts && ./install.sh
```

Persoanlly I have used the following configuration on my [iTerm](https://www.iterm2.com/).

| color-scheme | font-family | size | iv | nn |
|:------------:|:------------|:----:|:--:|:--:|
| atom | Font Meslo LG S for Powerline | 9pt | 100 | 100 |

At the end you have the following tools at your command:

| Command | Tool |
|:-------:|:-----|
| `vim`   | [vim](https://www.vim.org/) |
| `nvim`  | [NeoVim](https://neovim.io/) |
| `tmux`  | [tmux](https://github.com/tmux/tmux/wiki) |

Don't forget the git credential setup:

```sh
touch $HOME/.gitconfig
git config --global user.name "Parham Alvani"
git config --global user.email "parham.alvani@gmail.com"
```

Then you can install other tools with `start.sh`, here some examples:

```sh
# install docker with proxy (see <Breaking Sanctions> section for more details)
./start.sh -p docker -i
# install golang
./start.sh go
# install python
./start.sh python
# and many many more...
```

## Tips and Tricks
[![](https://img.shields.io/badge/askubuntu-bookmarks-orange?style=flat-square&logo=ubuntu)](https://askubuntu.com/users/425876/parham-alvani?tab=bookmarks)
[![](https://img.shields.io/badge/superuser-bookmarks-black?style=flat-square&logo=superuser)](https://superuser.com/users/1199014/parham-alvani?tab=bookmarks)

- You can use the following command in **sudo mode** to remove osx lags in our country that happens because of sanctions.

```sh
echo '0.0.0.0 ocsp.apple.com' >> /etc/hosts
```

- If you have any issues with the system local, you can use the following command to reconfigure it.

```sh
sudo dpkg-reconfigure locales
```

- Personally I have used [Workona](https://workona.com/) in Chrome.
In order to hide its hidden windows from the OSx dock, check `System Preferences -> Dock -> Minimize windows into application icon`.

- For using Level U Pro with Linux mint after using this dotfiles you must use `bluetoothctl`.
```
[bluetooth]# scan on
[bluetooth]# scan off
[bluetooth]# pair A0:60:90:37:C0:3C
[bluetooth]# trust A0:60:90:37:C0:3C
[bluetooth]# connect A0:60:90:37:C0:3C
[bluetooth]# info A0:60:90:37:C0:3C
```

- In order to fix a missing `apt` repository public key use the following:

```
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys <missing-public-key>
```

- You are working at a company with private git repository and you want to build a go project that has private dependencies. Following procedure will help you to setup a private access to your company's repositories.

```
git config --global url."ssh://git@gitlab.snapp.ir/".insteadOf "https://gitlab.snapp.ir/"
go env -w GOPRIVATE="gitlab.snapp.ir"
```

### Useful Apps

- [Draw.io Desktop](https://github.com/jgraph/drawio-desktop)

## Breaking Sanctions
Our country is under many unfair sanctions so you can use [v2ray](https://www.v2ray.com/en/) to remove these sanctions.
Use following command to install it.

```sh
curl -Ls https://install.direct/go.sh | sudo bash
```

You can configure it by many ways in `/etc/v2ray/config.json` but here is my sample.

```yaml
{
  "inbounds": [
    {
      "port": 1080,
      "protocol": "http"
    }, {
      "port": 1086,
      "protocol": "socks",
      "udp": true,
      "auth": "noauth"
    }
  ],

  "outbounds": [
    {
      "protocol": "shadowsocks",
      "settings": {
        "servers": [
          {
            "address": "an-awesome-server",
            "method": "aes-256-gcm",
            "ota": false,
            "password": "secret",
            "port": 1378
          }
        ]
      }
    }
  ]
}
```

Then after starting v2ray service `sudo systemctl start v2ray`, you can use the following commands in your shell to enable/disable http(s) proxy.

```sh
proxy_start   # enable http(s) proxy
proxy_stop    # disable http(s) proxy
```

or use the following **general** commands:

```sh
export {http,https,ftp}_proxy="http://127.0.0.1:1080" # enable http(s) proxy
unset {http,https,ftp}_proxy                          # disable http(s) proxy
```

To have environment variables with `sudo` you have to run it with `-E`.
Some apt repositories need proxy so you can configure them in `/etc/apt/apt.conf.d/99proxy`:

```
Acquire::http::Proxy::download.docker.com "http://127.0.0.1:1080";
```

For having proxy on docker use the following procedure:

```sh
sudo mkdir -p /etc/systemd/system/docker.service.d
```

Then update `/etc/systemd/system/docker.service.d/http-proxy.conf` with:

```
[Service]
Environment="HTTP_PROXY=http://127.0.0.1:1080/"
```

And reload the docker daemon:

```sh
sudo systemctl daemon-reload
sudo systemctl restart docker
```

## Cheatsheet
### vim

#### Go IDE

It's very simple, just execute `:GoInstallBinaries` in vim normal mode,
after that you have complete IDE for go in vim.

| Shortcut         | Description                         |
|:----------------:|:------------------------------------|
| `:GeDoc`         | go doc with [GoExplorer](https://github.com/garyburd/go-explorer) |
| `:GoDoc`         | GoDoc == GeDoc if vim-go is plugged |
| `:GoFillStruct`  | use `fillstruct` to fill a struct literal with default values. Existing values (if any) are preserved. The cursor must be on the struct you wish to fill |
| `:[range]GoAddTags [key],[option] [key1],[option] ...` | adds field tags for the fields of a struct |
| `:GoImpl [receiver] [interface]` | generates method stubs for implementing an interface |

To setup a complete golang environment use [this](https://hackernoon.com/my-neovim-setup-for-go-7f7b6e805876)
medium post.

#### Shortcuts

| Shortcut         | Description               |
|:----------------:|:--------------------------|
| `<C-n>`          | toggles [NerdTree](https://github.com/scrooloose/nerdtree)          |
| `<C-h>`          | toggles [SuperTab](https://github.com/ervandew/supertab)          |
| `<C-b>`          | toogles [Buffergator](https://github.com/jeetsukumaran/vim-buffergator)       |
| `<F5>`           | toggles [Tagbar](https://github.com/majutsushi/tagbar)            |
| `<C-u>`          | toggles [utlisnips](https://github.com/SirVer/ultisnips)         |
| `<C-w> <Left>`   | move to left window       |
| `<C-w> <Right>`  | move to right window      |
| `<C-w> <Up>`     | move to up window         |
| `<C-w> <Down>`   | move to down window       |
| `<C-w> s`        | new horizontal window     |
| `<C-w> v`        | new vertical window       |
| `<C-w> n`        | move to next tab          |
| `<C-w> p`        | move to previous tab      |
| `<C-w> c`        | new empty tab             |
| `<C-w> nn`       | move to tab number nn     |
| `-`              | leader Key                |
| `J`              | join lines                |
| `u`              | undo                      |
| `.`              | redo                      |

| Shortcut         | Description                         |
|:----------------:|:------------------------------------|
| `0` `$`          | begin/End of line                   |
| `G` `gg`         | begin/End of file                   |
| `w` `b`          | next/prev word                      |
| `<C-U>` `<C-D>`  | next/prev page                      |
| `H` `M` `L`      | top/mid/btm of win                  |
| `zt` `zz` `zb`   | scroll to top/mid/btm               |
| `%`              | matching parenthesis                |
| `[[ ]]`          | next/prev function/method           |

| Shortcut         | Description                         |
|:----------------:|:------------------------------------|
| `*` `#`          | find current word backward/forward  |
| `n` `N`          | next/prev search result             |

| Shortcut         | Description               | Shortcut         | Description                         |
|:----------------:|:--------------------------|:----------------:|:------------------------------------|
| `:b name`        | open buffer               | `:bd name`       | delete buffer                       |
| `:edit`          | reload current file       | `:Agit` | git log manager |
| `:edit!`         | reload current file force | `:edit x`        | edit file x                         |
| `:terminal`      | open terminal             | | |

| Shortcut         | Description                         |
|:----------------:|:------------------------------------|
| `<ESC>`          | enter *Normal* mode                 |
| `v`              | enter *Visual* mode                 |
| `V`              | enter *Visual Line* mode            |
| `i`              | enter *Insert* mode                 |
| `I`              | enter *Insert* mode [head of line]  |
| `a`              | enter *Insert* mode [next position] |
| `A`              | enter *Insert* mode [end of line]   |
| `R`              | enter *Replace* mode                |

| Shortcut | Description              |
|:--------:|:-------------------------|
| `s`      | open file vsplit         |
| `i`      | open file split          |
| `t`      | open file in new tab     |
| `o`      | open & close directory   |
| `m`      | show menu                |
| `I`      | toggle show hidden files |

### zsh

| Shortcut         | Description               |
|:----------------:|:--------------------------|
| `<C-R>`          | Enter to history mode     |
| `<C-G>`          | Exit from history mode    |

Use `escape` in order to enter vim mode for zsh.

| Shortcut   | Description               |
|:----------:|:--------------------------|
| `dd`       | Delete current line       |
| `$`        | Move to end of line       |
| `0`        | Move to head of line      |

These commands use for history searching in vim mode.

| Shortcut         | Description                         |
|:----------------:|:------------------------------------|
| `*` `#`          | Find current word backward/forward  |
| `n` `N`          | Next/Prev search result             |
| `/<exp>`         | Search for `<exp>` in hisory        |

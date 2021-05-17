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
![GitHub Workflow Status](https://img.shields.io/github/workflow/status/1995parham/dotfiles/Install%20dotfiles?label=install&logo=github&style=flat-square)
![GitHub Workflow Status](https://img.shields.io/github/workflow/status/1995parham/dotfiles/Shell%20Script%20Lint?label=sh-lint&logo=github&style=flat-square)

![Compatibiliy](https://img.shields.io/badge/works%20on-macos-grey?logo=macos&style=flat-square)
![Compatibiliy](https://img.shields.io/badge/works%20on-ubuntu-orange?logo=ubuntu&style=flat-square)
![Compatibiliy](https://img.shields.io/badge/works%20on-manjaro-green?logo=manjaro&style=flat-square)

## Introduction

This repository contains my personal configurations for ubuntu, manjaro (with i3 window manager), apple osx and even windows 10, which was created in Fall 2013 when I was a lonely BSc' student at the Amirkabir University of Technology.
First of all, thank you for your visiting, to find out more about how to use this configuration with neovim, oh-my-zsh, etc. please check the following sections.
Special thanks to [@elahe-dastan](https://github.com/elahe-dastan) for using this project and reporting its issues. Her unique contribution to this repository and my life is unforgettable.
The following list contains my personal software recommendation:

## Installation (Linux, OSx)

The following command creates a basic directory structure and clones the _dotfiles_ repository:

```sh
curl -sL https://raw.githubusercontent.com/1995parham/dotfiles/main/over-the-air-installation.sh | bash
```

Install required softwares with pacman/brew.

```sh
./start.sh env
```

Install configuration files with soft-links. This script also sets the zsh as a default shell and installs plugins on neovim and vim.

```sh
./install.sh
```

Install useful fonts.

```sh
./start.sh font
```

**Don't** forget the git credential setup:

```sh
touch $HOME/.gitconfig
git config --global user.name "Parham Alvani"
git config --global user.email "parham.alvani@gmail.com"
```

Then you can install other tools with `start.sh`, here are some examples:

```sh
# install docker with proxy (see <Breaking Sanctions> section for more details)
./start.sh docker
# install golang
./start.sh go
# install python
./start.sh python
# and many many more...
```

Configuration of mentioned applications also is a part of this repository.

## Installation (Windows)

First of all you need to install `scoop` and `chocolatey` as package managers and also add the `extra` bucket for `scoop`. **Install Everything by one of these package managers**. It can also be done by `.\start.ps1 env` too.

Then you can start installing the required application by hand from the application list.
I cannot use `vim` or `neovim` on windows so I use them on WSL with Ubuntu 20.04 and use VScode on Windows.
Also it would be nice to install [pshazz](https://github.com/lukesampson/pshazz) based on [this](https://github.com/lukesampson/scoop/wiki/Theming-Powershell) article to have nice powershell.

Following script install package managers besides some useful packages:

```powershell
.\start.ps1 env
.\start.ps1 font
```

Currently I use WSL with `git.exe` because of its hanging issue and also I have to remove passphase for windows private key because there is no way to store it somewhere.

I use `Windows Terminal` as my primary terminal with the follwing configuration:

```json
{
  "profiles": {
    "defaults": {
      "fontFace": "JetBrains Mono",
      "fontSize": 12
    }
  }
}
```

check [here](https://garrytrinder.github.io/2020/12/my-wsl2-windows-terminal-setup) for more information about beautiful wsl terminal.

Also it is fun to install `powertoys` with `sudo choco install powertoys`.

## Tips and Tricks

[![](https://img.shields.io/badge/askubuntu-bookmarks-orange?style=flat-square&logo=ubuntu)](https://askubuntu.com/users/425876/parham-alvani?tab=bookmarks)
[![](https://img.shields.io/badge/superuser-bookmarks-black?style=flat-square&logo=superuser)](https://superuser.com/users/1199014/parham-alvani?tab=bookmarks)
[![](https://img.shields.io/badge/serverfault-bookmarks-black?style=flat-square&logo=serverfault)](https://serverfault.com/users/590681/parham-alvani?tab=bookmarks)

<details>
<summary>issue with system local on ubuntu</summary>

use the following command to reconfigure it.

```sh
sudo dpkg-reconfigure locales
```

</details>

<details>
<summary>using bluetooth speaker/headphone</summary>

run `bluetoothctl`, then:

```
[bluetooth]# scan on
[bluetooth]# scan off
[bluetooth]# pair A0:60:90:37:C0:3C
[bluetooth]# trust A0:60:90:37:C0:3C
[bluetooth]# connect A0:60:90:37:C0:3C
[bluetooth]# info A0:60:90:37:C0:3C
```

</details>

<details>
<summary>fix a missing <code>apt</code> repository public key</summary>

```sh
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys <missing-public-key>
```

</details>

<details>
<summary>fingerprint at ubuntu</summary>

```sh
# Use fprintd (lacks gui)
sudo apt install fprintd libpam-fprintd

# Enroll specific finger
fprintd-enroll -f left-index-finger

# Finally, enable access by marking Fingerprint option with * using the spacebar key in:
sudo pam-auth-update
```

</details>

<details>
<summary>natural scrolling with <i>X11</i></summary>

Open the `/etc/X11/xorg.conf.d/30-touchpad.conf` file, then add the **natural scrolling** option:

```
Section "InputClass"
    ...
Option "Natural Scrolling" "true"
    ...
EndSection
```

</details>

<details>
<summary>swap alt and meta with <i>X11</i></summary>

Open the `/etc/X11/xorg.conf.d/00-keyboard.conf` file, then add the **altwin** option:

```
Section "InputClass"
    ...
Option "XkbOptions" "altwin:swap_alt_win"
    ...
EndSection
```

</details>

<details>
<summary>enable the keyring for applications run through the terminal, such as SSH</summary>

add the following to your `~/.bash_profile`, `~/.zshenv`, or similar:

```sh
if [ -n "$DESKTOP_SESSION" ];then
    eval $(gnome-keyring-daemon --start)
    export SSH_AUTH_SOCK
fi
```

</details>

<details>
<summary>do you have any HFP-only headphone?</summary>

Use the following procedure to have it on you Arch:

```sh
sudo pacman -Syu ofono phonesim

# validate the content of /etc/ofono/phonesim.conf
# [phonesim]
# Address=127.0.0.1
# Port=12345

sudo systemctl start ofono.service
phonesim -p 12345 /usr/share/phonesim/default.xml &
dbus-send --print-reply --system --dest=org.ofono /phonesim org.ofono.Modem.SetProperty string:"Powered" variant:boolean:"true"
```

</details>

<details>
<summary><b>don't</b> forget that you can configure <code>github-cli</code> to use existing tokens.</summary>
</details>

<details>
<summary>unsure samba on windows 10</summary>

```powershell
Write-Output "Provide a way for connecting to the unsecure samba"
Get-SmbClientConfiguration
Set-SmbClientConfiguration -EnableInsecureGuestLogons:$true
```

</details>

<details>
<summary>use proxy with chocolatey</summary>

```powershell
sudo choco install <pkg> --proxy="http://127.0.0.1:1080"
```

</details>

<details>
<summary>ubuntu mirrors in Iran</summary>

you can use the following stable and awesome mirror for your systems.
<strong>https://mirror.iranserver.com/</strong>

</details>

<details>
<summary>improve touch responsiveness on microsoft surface</summary>

follow <a href="https://www.windowscentral.com/how-improve-touch-response-surface">this</a> link to change registry.

</details>

## Breaking Sanctions

Our country is under many **unfair** sanctions so you can use [v2ray](https://www.v2ray.com/en/) on Linux to remove these sanctions.
Use following command to install it.

```sh
curl -O https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh
chmod +x install-release.sh
sudo ./install-release.sh
sudo systemctl enable v2ray
```

You can configure it by many ways in `/usr/local/etc/v2ray/config.json` but here is my example.

```json
{
  "inbounds": [
    { "port": 1080, "protocol": "http" },
    { "port": 1086, "protocol": "socks", "udp": true, "auth": "noauth" }
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
            "ivCheck": true,
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

## Firefox

I am using firefox as a main browser for daily basis.
Firefox is awesome and the latest version of my bookmarks are sync on it.
Firefox containers is a good way to have multiple account on the same time on a browser.

| Name     | Color  |          Gmail          |    Github     |
| :------- | :----: | :---------------------: | :-----------: |
| Main     |  None  | parham.alvani@gmail.com |  1995parham   |
| Personal |  Blue  |  1995parham@gmail.com   | parham-alvani |
| Elahe    | Yellow |  elahe.dstn@gmail.com   | elahe-dastan  |

## Cheatsheet

### vim

|    Shortcut     | Description                                                             |
| :-------------: | :---------------------------------------------------------------------- |
|     `<C-n>`     | toggles [NerdTree](https://github.com/scrooloose/nerdtree)              |
|     `<C-h>`     | toggles [SuperTab](https://github.com/ervandew/supertab)                |
|     `<C-b>`     | toogles [Buffergator](https://github.com/jeetsukumaran/vim-buffergator) |
|     `<F5>`      | toggles [Tagbar](https://github.com/majutsushi/tagbar)                  |
|     `<C-u>`     | toggles [utlisnips](https://github.com/SirVer/ultisnips)                |
| `<C-w> <Left>`  | move to left window                                                     |
| `<C-w> <Right>` | move to right window                                                    |
|  `<C-w> <Up>`   | move to up window                                                       |
| `<C-w> <Down>`  | move to down window                                                     |
|    `<C-w> s`    | new horizontal window                                                   |
|    `<C-w> v`    | new vertical window                                                     |
|    `<C-w> n`    | move to next tab                                                        |
|    `<C-w> p`    | move to previous tab                                                    |
|    `<C-w> c`    | new empty tab                                                           |
|   `<C-w> nn`    | move to tab number nn                                                   |
|    `<space>`    | leader Key                                                              |
|       `J`       | join lines                                                              |
|       `u`       | undo                                                                    |
|     `<C-r>`     | redo                                                                    |

|    Shortcut     | Description               |
| :-------------: | :------------------------ |
|     `0` `$`     | begin/End of line         |
|    `G` `gg`     | begin/End of file         |
|     `w` `b`     | next/prev word            |
| `<C-U>` `<C-D>` | next/prev page            |
|   `H` `M` `L`   | top/mid/btm of win        |
| `zt` `zz` `zb`  | scroll to top/mid/btm     |
|       `%`       | matching parenthesis      |
|     `[[ ]]`     | next/prev function/method |

| Shortcut | Description                        |
| :------: | :--------------------------------- |
| `*` `#`  | find current word backward/forward |
| `n` `N`  | next/prev search result            |

|  Shortcut   | Description               |  Shortcut  | Description     |
| :---------: | :------------------------ | :--------: | :-------------- |
|  `:b name`  | open buffer               | `:bd name` | delete buffer   |
|   `:edit`   | reload current file       |  `:Agit`   | git log manager |
|  `:edit!`   | reload current file force | `:edit x`  | edit file x     |
| `:terminal` | open terminal             |            |                 |

| Shortcut | Description                         |
| :------: | :---------------------------------- |
| `<ESC>`  | enter _Normal_ mode                 |
|   `v`    | enter _Visual_ mode                 |
|   `V`    | enter _Visual Line_ mode            |
|   `i`    | enter _Insert_ mode                 |
|   `I`    | enter _Insert_ mode [head of line]  |
|   `a`    | enter _Insert_ mode [next position] |
|   `A`    | enter _Insert_ mode [end of line]   |
|   `R`    | enter _Replace_ mode                |

| Shortcut | Description              |
| :------: | :----------------------- |
|   `s`    | open file vsplit         |
|   `i`    | open file split          |
|   `t`    | open file in new tab     |
|   `o`    | open & close directory   |
|   `m`    | show menu                |
|   `I`    | toggle show hidden files |

#### Go

It's very simple, just execute `:GoInstallBinaries` in vim normal mode,
after that you have complete IDE for go in vim. :dancer:

|                        Shortcut                        | Description                                                                                                                                              |
| :----------------------------------------------------: | :------------------------------------------------------------------------------------------------------------------------------------------------------- |
|                        `:GeDoc`                        | go doc with [GoExplorer](https://github.com/garyburd/go-explorer)                                                                                        |
|                        `:GoDoc`                        | GoDoc == GeDoc if vim-go is plugged                                                                                                                      |
|                    `:GoFillStruct`                     | use `fillstruct` to fill a struct literal with default values. Existing values (if any) are preserved. The cursor must be on the struct you wish to fill |
| `:[range]GoAddTags [key],[option] [key1],[option] ...` | adds field tags for the fields of a struct                                                                                                               |
|            `:GoImpl [receiver] [interface]`            | generates method stubs for implementing an interface                                                                                                     |

To setup a complete golang environment use [this](https://hackernoon.com/my-neovim-setup-for-go-7f7b6e805876)
medium post.

### zsh

| Shortcut | Description            |
| :------: | :--------------------- |
| `<C-R>`  | Enter to history mode  |
| `<C-G>`  | Exit from history mode |

Use `escape` in order to enter vim mode for zsh.

| Shortcut | Description          |
| :------: | :------------------- |
|   `dd`   | Delete current line  |
|   `$`    | Move to end of line  |
|   `0`    | Move to head of line |

These commands use for history searching in vim mode.

| Shortcut | Description                        |
| :------: | :--------------------------------- |
| `*` `#`  | Find current word backward/forward |
| `n` `N`  | Next/Prev search result            |
| `/<exp>` | Search for `<exp>` in hisory       |

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

[![license](https://img.shields.io/github/license/1995parham/dotfiles.svg?style=flat-square)]()
[![Drone (cloud)](https://img.shields.io/drone/build/1995parham/dotfiles.svg?style=flat-square)](https://cloud.drone.io/1995parham/dotfiles)
[![Codacy Badge](https://api.codacy.com/project/badge/Grade/02e3f859b8944e749d1ceca4a4c41e49)](https://www.codacy.com/app/1995parham/dotfiles?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=1995parham/dotfiles&amp;utm_campaign=Badge_Grade)

## Introduction

This repository contains my personal's configurations for Ubuntu and OSx, which has been created in Fall 2013 when I was a lonely BSc' student at the Amirkabir University of Technology. First of all, thank you for your visiting, to find out more about how to use this configuration with NeoVIM, Oh-My-Zsh, etc. please check the following sections.

## Table of Contents

- [How To...](docs/how.md)
- [VIM](docs/vim.md)
- [ZSH](docs/zsh.md)

## Frameworks
<p align="center">
  <img src="https://raw.githubusercontent.com/neovim/neovim.github.io/master/logos/neovim-logo-600x173.png" />
</p>
<p align="center">
  <img src="https://camo.githubusercontent.com/5c385f15f3eaedb72cfcfbbaf75355b700ac0757/68747470733a2f2f73332e616d617a6f6e6177732e636f6d2f6f686d797a73682f6f682d6d792d7a73682d6c6f676f2e706e67">
</p>

## Installation
Over-the-Air-Installation :joy:

```sh
curl -L https://raw.githubusercontent.com/1995parham/dotfiles/master/over-the-air-installation.sh | bash
```

Ubuntu Universal Repository (if you are on ubuntu :joy:)

```sh
sudo add-apt-repository "deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc) universe"
```

Install [brew.sh](http://brew.sh) for OSx and even Linux

```sh
./start.sh brew
test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
```

Install required softwares

```sh
./start.sh env
```

Setup configuration files

```sh
./install.sh
```

Install useful fonts

```sh
cd fonts && ./install.sh
```

Install iTerm on OSx and use the following configuration

```
Color Scheme fron ./iterm
Font Meslo LG S for Powerline 9pt 100iv 100nn
```

Remove OSx Lags (if you are on osx :joy:)

```sh
echo '0.0.0.0 ocsp.apple.com' >> /etc/hosts
```

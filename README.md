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

## Introduction

This repository contains my personal's configurations for Ubuntu and OSx, which has been created in Fall 2013 when I was a lonely BSc' student at the Amirkabir University of Technology. First of all, thank you for your visiting, to find out more about how to use this configuration with NeoVIM, Oh-My-Zsh, etc. please check the following sections.

## Table of Contents

- [How To...](docs/how.md)
- [VIM](docs/vim.md)
- [ZSH](docs/zsh.md)

## Installation
The following command creates a basic directory structure and clones the **dotfiles** repository:

```sh
curl -L https://raw.githubusercontent.com/1995parham/dotfiles/master/over-the-air-installation.sh | bash
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

Install useful fonts.

```sh
cd fonts && ./install.sh
```

Persoanlly I have used the following configuration on my [iTerm](https://www.iterm2.com/).

```
Color Scheme fron ./iterm
Font Meslo LG S for Powerline 9pt 100iv 100nn
```

## Tips and Tricks

- You can use the following command in **sudo mode** to remove osx lags in our country that happens because of sanctions.

```sh
echo '0.0.0.0 ocsp.apple.com' >> /etc/hosts
```

- Personally I have used [Workona](https://workona.com/) in Chrome.
In order to hide its hidden windows from the OSx dock, check `System Preferences -> Dock -> Minimize windows into application icon`.

```
     _       _    __ _ _
  __| | ___ | |_ / _(_) | ___  ___
 / _` |/ _ \| __| |_| | |/ _ \/ __|
| (_| | (_) | |_|  _| | |  __/\__ \
 \__,_|\___/ \__|_| |_|_|\___||___/

 _  ___   ___  ____                   _
/ |/ _ \ / _ \| ___| _ __   __ _ _ __| |__   __ _ _ __ ___
| | (_) | (_) |___ \| '_ \ / _` | '__| '_ \ / _` | '_ ` _ \
| |\__, |\__, |___) | |_) | (_| | |  | | | | (_| | | | | | |
|_|  /_/   /_/|____/| .__/ \__,_|_|  |_| |_|\__,_|_| |_| |_|
                    |_|
```

![GitHub](https://img.shields.io/github/license/1995parham/dotfiles?logo=gnu&style=flat-square)
![GitHub Workflow Status](https://img.shields.io/github/workflow/status/1995parham/dotfiles/Install%20dotfiles?label=install&logo=github&style=flat-square)
![GitHub Workflow Status](https://img.shields.io/github/workflow/status/1995parham/dotfiles/Shell%20Script%20Lint?label=sh-lint&logo=github&style=flat-square)

## Introduction

This repository contains my personal configurations for ubuntu, manjaro (with i3 window manager), apple osx and even windows 10, which was created in Fall 2013 when I was a lonely BSc' student at the Amirkabir University of Technology.
First of all, thank you for your visiting, to find out more about how to use this configuration with neovim, oh-my-zsh, etc. please check the following sections.
Special thanks to [@elahe-dastan](https://github.com/elahe-dastan) for using this project and reporting its issues. Her unique contribution to this repository and my life is unforgettable.

## Installation

![Compatibiliy](https://img.shields.io/badge/works%20on-macos-white?logo=macos&style=for-the-badge)
![Compatibiliy](https://img.shields.io/badge/works%20on-ubuntu-orange?logo=ubuntu&style=for-the-badge)
![Compatibiliy](https://img.shields.io/badge/works%20on-manjaro-green?logo=manjaro&style=for-the-badge)

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

## Installation

![Compatibiliy](https://img.shields.io/badge/partially%20works%20on-windows-blue?logo=windows&style=for-the-badge)

First of all you need to install `scoop` and `winget` as package managers and also add the `extra` bucket for `scoop`.
**Install Everything by one of these package managers**.

```powershell
Set-ExecutionPolicy Unrestricted
.\start.ps1 env
.\start.ps1 font
```

Then you can start installing the required application by hand from the application list.

Having terminal with powershell on windows is the only way to have a terminal.
With [oh-my-posh](https://ohmyposh.dev/docs/fonts) you can have a nicer prompt. please also note that, you will need a nerd font too.
I use `Windows Terminal` as my primary terminal with the follwing configuration:

```json
{
  "profiles": {
    "defaults": {
      "fontFace": "MesloLGM NF"
    }
  }
}
```

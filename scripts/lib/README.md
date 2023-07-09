# Dotfiles Library

## Introduction

There are scripts that help you maintain your dotfiles easier and more fun.
Library contains bash script for installing requirements, printing colorful messages, set-up proxy, etc.

## How to use it?

Clone this repository into your dotfiles folder:

```bash
mkdir scripts
git clone https://github.com/1995parham/dotfiles.lib.git scripts/lib
```

Then link the `start.sh` into your root's dotfiles:

```bash
ln -s start.sh scripts/lib/start.sh
```

Then you can start creating your setup scripts using:

```bash
./start.sh new
```

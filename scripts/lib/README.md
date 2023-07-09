# Dotfiles Library

## Introduction

There are scripts that help you maintain your dotfiles easier and more fun.
Library contains bash script for installing requirements, printing colorful messages, set-up proxy, etc.

## How to use it?

Clone this repository into your dotfiles folder (here we are using [git-subtree](https://www.atlassian.com/git/tutorials/git-subtree)):

```bash
mkdir scripts
git subtree add --prefix scripts/lib https://github.com/1995parham/dotfiles.lib.git main --squash
```

Then link the `start.sh` into your root's dotfiles:

```bash
ln -s scripts/lib/start.sh start.sh
```

Then you can start creating your setup scripts using:

```bash
./start.sh new
```

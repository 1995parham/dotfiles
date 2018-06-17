#!/bin/zsh
# In The Name Of God
# ========================================
# [] File Name : revel.plugin.zsh
#
# [] Creation Date : 08-06-2018
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================

function _revel() {
	subcmds=('new:Creates a few files to get a new Revel application running quickly'\
		'run:'\
		'build:Build the Revel web application named by the given import path'\
		'clean:Clean the Revel web application named by the given import path'\
		'test:Run all tests for the Revel app named by the given import path.')
	_describe 'command' subcmds
}

compdef _revel revel

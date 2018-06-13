#!/bin/zsh
# In The Name Of God
# ========================================
# [] File Name : buffalo.plugin.zsh
#
# [] Creation Date : 08-06-2018
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================

function _buffalo() {
	local line

	cmds="((build\:'Builds a Buffalo binary, including bundling of assets (packr & webpack)'
		db\:'A tasty treat for all your database needs'
		destroy\:'Allows to destroy generated code.'
		dev\:'Runs your Buffalo app in development mode'
		generate\:'A collection of generators to make life easier'
		help\:'Help about any command'
		info\:'Prints off diagnostic information useful for debugging'
		new\:'Creates new Buffalo application'
		setup\:'Setups a newly created, or recently checked out application.'
		task\:'Runs your grift tasks'
		test\:'Runs the tests for your Buffalo app'
		update\:'will attempt to upgrade a Buffalo application to newer version'
		version\:'Print the version number of buffalo'))"
	_arguments -C \
		"1:command:$cmds"\
		"*::arg:->args"

	case $line[1] in
		b|bill|build)
			_buffalo_build
			;;
		g|generate)
			_buffalo_generate
			;;
		new)
			_buffalo_new
			;;
	esac
}

function _buffalo_new() {
	_arguments \
		"1:name"\
		"--api[skip all front-end code and configure for an API server]"\
		"--bootstrap[specify version for Bootstrap \\[3, 4\\] (default 3)]"\
		"--ci-provider[specify the type of ci file you would like buffalo to generate \\[none, travis, gitlab-ci\\] (default none)]"\
		"--db-type[specify the type of database you want to use \\[postgres, mysql, cockroach\\] (default postgres)]"\
		"--docker[specify the type of Docker file to generate \\[none, multi, standard\\] (default multi)]"\
		"-f[delete and remake if the app already exists]"\
		"-h[help for new]"\
		"--skip-pop[skips adding pop/soda to your app]"\
		"--skip-webpack[skips adding Webpack to your app]"\
		"--skip-yarn[use npm instead of yarn for frontend dependencies management]"\
		"--vcs[specify the Version control system you would like to use \\[none, git, bzr\\] (default git)]"\
		"-v[verbosely print out the go get commands]"\
		"--with-dep[adds github.com/golang/dep to your dep]"
}

function _buffalo_generate() {
	local line

	cmds="((action\:'Generates new action(s)'
		docker\:'Generates a Dockerfile'
		mailer\:'Generates a new mailer for Buffalo'
		resource\:'Generates a new action/resource file'
		task\:'Generates a grift task'))"
	_arguments -C \
		"1:command:$cmds"\
		"*::arg:->args"

	case $line[1] in
		a|action|actions)
			_buffalo_generate_action
			;;
	esac

}

function _buffalo_generate_action() {
	_arguments \
		"-h[help for action]"\
		"-m[change the HTTP method for the generate action(s) (default GET)]"\
		"--skip-template[skip generation of templates for action(s)]"
		"1:name"\
		"*:handler name..."
}

function _buffalo_build() {
	_arguments \
		"-c[compress static files in the binrary (default true)]"\
		"-d[print debugging informantion]"
}

compdef _buffalo buffalo

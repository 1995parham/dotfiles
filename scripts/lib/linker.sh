#!/bin/bash

root=${root:?"root must be set"}
yes_to_all=${yes_to_all:-false}

# copy a file into destination. it only works on files and shows
# the difference before doing the copy. it useful for setup files in /etc, /usr, etc.
copycat() {
	local module=${1:?"module name required"}
	local src=${2:?"copycat requires source"}
	local dest=${3:?"copycat requires destination"}
	local sudo=${4:-1}
	local ask=0

	message "$module" "difference between $root/$src and $dest:"
	echo
	echo
	if [ "$sudo" == 1 ]; then
		if ! sudo diff -yNs --suppress-common-lines "$root/$src" "$dest"; then
			ask=1
		fi
	else
		if ! diff -yNs --suppress-common-lines "$root/$src" "$dest"; then
			ask=1
		fi
	fi
	echo
	echo

	if [ "$ask" == 1 ]; then
		if ! yes_or_no "$module" "do you want to replace $dest?"; then
			return 1
		fi
	fi

	if [ "$sudo" == 1 ]; then
		sudo cp "$root/$src" "$dest"
	else
		cp "$root/$src" "$dest"
	fi
}

# creates a config file that resides in the `home` directory, and provides a soft link to it.
# parameter 1: module name - string
# parameter 2: file name - string
# parameter 3 [default = true]: add dot into the destination file (consider it as hidden)
dotfile() {
	local module=${1:?"module name required"}
	local file=${2:-""}
	local is_hidden=${3:-true}

	if $is_hidden; then
		local dst_file=".${file:-$module}"
	else
		local dst_file="${file:-$module}"
	fi

	local src_file="$file"

	local dst_path="$HOME/$dst_file"
	local src_path="$root/$module/$src_file"

	linker "$module" "$src_path" "$dst_path"
}

# creates a config file that resides in the `.config` directory, and provides a soft link to it.
# for better organization of the repository, modules can be gathered into a directory, in these cases
# the third parameter is used.
# parameter 1: module name - string
# parameter 2: file name - string - optional
# parameter 3: directory - string - optional
configfile() {
	local module=${1:?"module name required"}
	local src_file=${2:-""}
	local src_dir=${3:-""}

	if [ ! -e "$HOME/.config" ]; then
		mkdir "$HOME/.config"
	fi

	if [ -n "$src_file" ]; then
		local src_path="$root${src_dir:+/$src_dir}/$module/$src_file"
		local dst_file="$module/$src_file"

		if [ ! -d "$HOME/.config/$module" ]; then
			mkdir "$HOME/.config/$module"
		fi
	else
		src_file=$module
		local src_path="$root${src_dir:+/$src_dir}/$module"
		local dst_file="$module"
	fi
	local dst_path="$HOME/.config/$dst_file"

	linker "$module" "$src_path" "$dst_path"
}

# linker does the soft linking, it has a yes_to_all parameter which you can use to skip the question phase
# parameter 1: module name - string which is used only in logs.
# parameter 2: source path - string
# parameter 3: destination path - string
linker() {
	local module=${1:?"module name required"}
	local src_path=${2:?"linker requires src_path"}
	local dst_path=${3:?"linker requires dst_path"}

	local create_link=true

	if [ -e "$dst_path" ] || [ -L "$dst_path" ]; then
		message "$module" "$dst_path has already existed"

		if [[ $src_path = $(readlink "$dst_path") ]]; then
			message "$module" "$dst_path points to the correct location"
			create_link=false
			return
		fi

		if yes_or_no "$module" "do you want to remove $dst_path?"; then
			rm -R "$dst_path"
			action "$module" "$dst_path is removed successfully"
		else
			create_link=false
		fi
	fi

	if $create_link; then
		ln -s "$src_path" "$dst_path"
		action "$module" "symbolic link created successfully from $src_path to $dst_path"
	fi
}

# creates a config file that resides in the `.config` directory, and provides a soft link for it.
# for better organization of the repository, modules can be gathered into a directory, in these cases
# the third parameter is used.
# parameter 1: module name - string
# parameter 2: file name - string
# parameter 3: directory - string - optional
configrootfile() {
	local module=${1:?"module name required"}
	local src_file=${2:?"configrootfile requires src_file"}
	local src_dir=${3:-""}

	if [ ! -e "$HOME/.config" ]; then
		mkdir "$HOME/.config"
	fi

	if [ -n "$src_file" ]; then
		local src_path="$root${src_dir:+/$src_dir}/$module/$src_file"
		local dst_file="$src_file"
	fi
	local dst_path="$HOME/.config/$dst_file"

	linker "$module" "$src_path" "$dst_path"
}

# creates a systemd file that resides in the `.config` directory, and provides a soft link for it.
# for better organization of the repository, modules can be gathered into a directory, in these cases
# the third parameter is used.
# parameter 1: module name - string
# parameter 2: file name - string
# parameter 3: directory - string - optional
configsystemd() {
	local module=${1:?"module name required"}
	local src_file=${2:?"configsystemd requires src_file"}
	local src_dir=${3:-""}

	if [ ! -e "$HOME/.config/systemd/user" ]; then
		mkdir -p "$HOME/.config/systemd/user"
	fi

	if [ -n "$src_file" ]; then
		local src_path="$root${src_dir:+/$src_dir}/$module/$src_file"
		local dst_file="$src_file"
	fi
	local dst_path="$HOME/.config/systemd/user/$dst_file"

	linker "$module" "$src_path" "$dst_path"
}

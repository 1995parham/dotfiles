# creates a config file that resides in the `home` directory, and provides a soft link to it.
# parameter 1: module name - string
# parameter 2: file names - array of string
# parameter 3 [default = true]: is hidden file (starts with dot) - bool
dotfile() {
	local module=$1
	local files=${!2}
	local is_hidden=${3:-true}

	for file in $files; do
		if $is_hidden; then
			local dst_file=".$file"
		else
			local dst_file="$file"
		fi

		local src_file="$file"

		local dst_path="$HOME/$dst_file"
		local src_path="$current_dir/$module/$src_file"

		linker $module $src_path $dst_path
	done
}

# creates a config file that resides in the `.config` directory, and provides a soft link to it.
# for better organization of the repository, modules can be gathered into a directory, in these cases
# the third parameter is used.
# parameter 1: module name - string
# parameter 2: file name - string - optional
# parameter 3: directory - string - optional
configfile() {
	local module=$1
	local src_file=$2
	local src_dir=$3

	if [ ! -e "$HOME/.config" ]; then
		mkdir "$HOME/.config"
	fi

	if [ ! -z $src_file ]; then
		local src_path="$current_dir${src_dir:+/$src_dir}/$module/$src_file"
		local dst_file="$module/$src_file"

		if [ ! -d "$HOME/.config/$module" ]; then
			mkdir "$HOME/.config/$module"
		fi
	else
		src_file=$module
		local src_path="$current_dir${src_dir:+/$src_dir}/$module"
		local dst_file="$module"
	fi
	local dst_path="$HOME/.config/$dst_file"

	linker $module $src_path $dst_path
}

# linker
# parameter 1: module name - string
# parameter 2: source path - string
# parameter 3: destination path - string
linker() {
	local module=$1
	local src_path=$2
	local dst_path=$3

	local create_link=true

	if [ -e $dst_path ] || [ -L $dst_path ]; then
		message "$module" "$dst_path has already existed"

		if [[ $src_path = $(readlink $dst_path) ]]; then
			message "$module" "$dst_path points to the correct location"
			create_link=false
			return
		fi

		if [[ $yes_to_all == 0 ]]; then
			read -p "[$module] do you want to remove $dst_path ?[Y/n] " -n 1 delete_confirm
			echo
		fi

		if [[ $delete_confirm == "Y" ]] || [[ $yes_to_all == 1 ]]; then
			rm -R $dst_path
			message "$module" "$dst_path is removed successfully"
		else
			create_link=false
		fi
	fi

	if $create_link; then
		ln -s $src_path $dst_path
		message "$module" "Symbolic link created successfully from $src_path to $dst_path"
	fi
}

# creates a config file that resides in the `.config` directory, and provides a soft link for it.
# for better organization of the repository, modules can be gathered into a directory, in these cases
# the third parameter is used.
# parameter 1: module name - string
# parameter 2: file name - string
# parameter 3: directory - string - optional
configrootfile() {
        local module=$1
        local src_file=$2
        local src_dir=$3

        if [ ! -e "$HOME/.config" ]; then
                mkdir "$HOME/.config"
        fi

        if [ ! -z $src_file ]; then
                local src_path="$current_dir${src_dir:+/$src_dir}/$module/$src_file"
                local dst_file="$src_file"
        fi
        local dst_path="$HOME/.config/$dst_file"

        linker $module $src_path $dst_path
}

# creates a systemd file that resides in the `.config` directory, and provides a soft link for it.
# for better organization of the repository, modules can be gathered into a directory, in these cases
# the third parameter is used.
# parameter 1: module name - string
# parameter 2: file name - string
# parameter 3: directory - string - optional
configsystemd() {
        local module=$1
        local src_file=$2
        local src_dir=$3

        if [ ! -e "$HOME/.config/systemd/user" ]; then
                mkdir -p "$HOME/.config/systemd/user"
        fi

        if [ ! -z $src_file ]; then
                local src_path="$current_dir${src_dir:+/$src_dir}/$module/$src_file"
                local dst_file="$src_file"
        fi
        local dst_path="$HOME/.config/systemd/user/$dst_file"

        linker $module $src_path $dst_path
}

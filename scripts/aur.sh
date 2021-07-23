usage() {
	echo -n "1995parham's aur packages"

	echo '
  __ _ _   _ _ __
 / _| | | | | |__|
| (_| | |_| | |
 \__,_|\__,_|_|
'
}

main() {
	mkdir -p "$HOME/Documents/Git/parham/aur"

	git clone aur@aur.archlinux.org:natscli "$HOME/Documents/Git/parham/aur/natscli"
	git clone aur@aur.archlinux.org:okd-client-bin "$HOME/Documents/Git/parham/aur/okd-client-bin"
	git clone aur@aur.archlinux.org:gopass-jsonapi-bin "$HOME/Documents/Git/parham/aur/gopass-jsonapi-bin"
	git clone aur@aur.archlinux.org:jwt-cli-bin "$HOME/Documents/Git/parham/aur/jwt-cli-bin"
}

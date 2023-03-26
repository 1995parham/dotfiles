#!/bin/bash

# this script is written to works with its custom udev rules.
# to add a new disk you must first run the following command:
#
# udevadm info --attribute-walk --name <device>
#
# then you have the required conditions to write udev-rule.
# after that you must label your partition and then you are good
# to go.
#
# for btrfs you can use:
#
# sudo btrfs filesystem label /dev/sda2 parham-main

declare -a labels
labels=(
	"parham-main"
)

me="parham"

_mount() {
	local devbase=$1
	local device="/dev/$devbase"

	# see if this drive is already mounted
	mount_point="$(/bin/mount | /bin/grep "${device}" | /usr/bin/awk '{ print $3 }')"

	if [[ -n ${mount_point} ]]; then
		# already mounted, exit
		exit 1
	fi

	# get info for this drive: $ID_FS_LABEL, $ID_FS_UUID, and $ID_FS_TYPE
	eval "$(/sbin/blkid -o udev "${device}")"

	# Figure out a mount point to use
	label=${ID_FS_LABEL}
	if [[ -z "${label}" ]]; then
		exit
	fi

	if [[ ! " ${labels[*]} " == *" $label "* ]]; then
		exit
	fi

	mount_point="/media/${label}"

	/bin/mkdir -p "${mount_point}"

	# global mount options
	opts="rw,relatime"

	# file system type specific mount options
	if [[ ${ID_FS_TYPE} == "vfat" ]]; then
		opts+=",users,grou=1000,user=1000,umask=000,shortname=mixed,utf8=1,flush"
	fi

	if ! /bin/mount -o "${opts}" "${device}" "${mount_point}"; then
		# error during mount process: cleanup mountpoint
		/bin/rmdir "${mount_point}"
		exit 1
	fi

	# send desktop notification to user
	sudo -u "$me" DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus notify-send "device ${label} mounted"
}

_umount() {
	local devbase=$1
	local device="/dev/$devbase"

	# see if this drive is already mounted
	mount_point="$(/bin/mount | /bin/grep "${device}" | /usr/bin/awk '{ print $3 }')"

	if [[ -n ${mount_point} ]]; then
		/bin/umount -l "${device}"
	fi

	declare -a labels

	# delete all empty dirs in /media that aren't being used as mount points.
	# the list of current mounted disks exists in /etc/mtab
	for f in /media/*; do
		if [[ -n $(/usr/bin/find "$f" -maxdepth 0 -type d -empty) ]]; then
			if ! /bin/grep -q " $f " /etc/mtab; then
				/bin/rmdir "$f"
			fi
		fi
	done
}

main() {
	if [ $# != 2 ]; then
		return
	fi

	case $1 in
	mount)
		_mount "$2"
		;;
	umount)
		_umount "$2"
		;;
	esac
}

main "$@"

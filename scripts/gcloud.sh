#!/bin/bash

usage() {
	echo "A set of command-line tools for the Google Cloud Platform.
  Includes gcloud (with beta and alpha commands), gsutil, and bq."

	# shellcheck disable=1004,2016
	echo '
            _                 _
  __ _  ___| | ___  _   _  __| |
 / _` |/ __| |/ _ \| | | |/ _` |
| (_| | (__| | (_) | |_| | (_| |
 \__, |\___|_|\___/ \__,_|\__,_|
 |___/
  '
}

main_pacman() {
	proxy_start
	require_aur google-cloud-cli
	proxy_stop
}

main() {
	proxy_start
	gcloud auth list
	gcloud auth login
	proxy_stop
}

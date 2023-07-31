#!/bin/bash

echo
echo '********************'
echo 'prepare-commit-msg.sh will create a prepare-commit-msg hook in your repsitory'
echo 'so you can see last commit messages in your commit message template and helps you to write a better commit message'
echo '********************'
echo

if [ ! -d '.git' ]; then
	echo 'you should be in the root of your repository'
	exit 1
fi

if [ ! -d '.git/hooks' ]; then
	mkdir .git/hooks
fi

# shellcheck disable=2016
printf '%s' '
#!/bin/sh
ORIG_MSG_FILE="$1"                # Grab the current template
TEMP=$(mktemp /tmp/git-msg-XXXXX) # Create a temp file
trap "rm -f $TEMP" exit           # Remove temp file on exit

MSG=$(git log -5 --pretty=%s) # Grab the first line of the last commit message

(
  printf "\n\n# Last Commit: %s \n\n" "$MSG"
  cat "$ORIG_MSG_FILE"
) >"$TEMP"                    # print all to temp file
cat "$TEMP" >"$ORIG_MSG_FILE" # Move temp file to commit message
' >.git/hooks/prepare-commit-msg

chmod +x .git/hooks/prepare-commit-msg

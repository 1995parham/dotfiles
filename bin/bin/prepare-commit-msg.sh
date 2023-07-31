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

ORIG_MSG_FILE="$1"
TEMP=$(mktemp /tmp/git-msg-XXXXX)
trap "rm -f $TEMP" exit

(
  printf "# ---------- \n"
  git log -5 --pretty=%s | xargs -I{} printf "# %s\n" {}
  printf "# ---------- \n"
  cat "$ORIG_MSG_FILE"
) >"$TEMP"                    # print all to temp file
cat "$TEMP" >"$ORIG_MSG_FILE" # Move temp file to commit message
' >.git/hooks/prepare-commit-msg

chmod +x .git/hooks/prepare-commit-msg

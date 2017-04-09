zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes

function docker-ip() {
  sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' "$@"
}

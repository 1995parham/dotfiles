function killsh --argument 1
  lsof -ti:"$1" | xargs kill -9
end

function fwdpg --argument 1 2
  ssh -N -f -L "$2":localhost:"$2" ubuntu@os-playground"$1"
end

function pg --argument 1
  ssh os-playground"$1"
end

function fwdhulk --argument 1
  ssh -N -f -L "$1":localhost:"$1" hulk
end

alias hulk="ssh hulk"

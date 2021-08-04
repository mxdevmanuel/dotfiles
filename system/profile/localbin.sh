# Added local bin directory

local localbin=$HOME/.local/bin
[ -d $localbin ] && append_path "$localbin"

export PATH


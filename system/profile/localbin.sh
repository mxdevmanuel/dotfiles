# Added local bin directory

localbin=$HOME/.local/bin

[ -d $localbin ] && append_path "$localbin"

export PATH


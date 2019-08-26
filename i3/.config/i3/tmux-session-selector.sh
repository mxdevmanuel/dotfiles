tmux ls | perl -pe 's/:.*$//g' | dmenu_themed | xargs -I% termite -e "tmux a -t '%'"

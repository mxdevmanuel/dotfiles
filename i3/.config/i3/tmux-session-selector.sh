tmux ls | perl -pe 's/:.*$//g' | dmenu | xargs -I% termite -e "tmux a -t '%'"

tmux ls | perl -pe 's/:.*$//g' | dmenu | xargs -I% kitty /usr/bin/tmux a -t '%'

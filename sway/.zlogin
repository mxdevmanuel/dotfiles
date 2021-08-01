export FIRSTRUN=1
export EMOJI_SELECT_MENU="wofi --dmenu --matching=fuzzy -p 'Emoji'"
export EMOJI_COPY_TOOL="wl-copy"

if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
  exec sway
fi


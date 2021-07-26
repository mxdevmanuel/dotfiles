export FIRSTRUN=1
if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
  exec startx
fi


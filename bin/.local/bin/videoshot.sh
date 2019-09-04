#!/usr/bin/env bash
#
# videoshot - script for capturing videos and uploading them to filebin
#
# Copyright (c) 2018 by Christian Rebischke <chris@nullday.de>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http: #www.gnu.org/licenses/
#
#======================================================================
# Author: Christian Rebischke
# Email : chris@nullday.de
# Github: www.github.com/shibumi

round() {
  echo $((${1:?need one argument} / 2 * 2))
}

readonly VIDEOSHOTDIR="$HOME/.cache/videoshot"

if [[ ! -e $VIDEOSHOTDIR ]]; then
  mkdir -p "$VIDEOSHOTDIR"
fi

readonly PIDPATH="$VIDEOSHOTDIR/videoshot.pid"
readonly RESOURCEPATH="$VIDEOSHOTDIR/videoshot.txt"

if [[ ! -f "$PIDPATH" ]]; then
  readonly border="-show_region 1"
  readonly rect_encopts="-r 30 -c:v libx264 -preset slow -crf 18 -c:a libvorbis"
  readonly ffmpeg_display=$DISPLAY
  read -r X Y W H G ID < <(slop -f "%x %y %w %h %g %i")
  readonly X=$(round $X)
  readonly Y=$(round $Y)
  readonly W=$(round $W)
  readonly H=$(round $H)
  readonly TIME="$(date +%Y-%m-%d-%H-%M-%S)"
  readonly VIDPATH="$VIDEOSHOTDIR/rec-$TIME.mp4"
  (
    ffmpeg -f x11grab ${border} -s "$W"x"$H" -i $ffmpeg_display+$X,$Y $rect_encopts "$VIDPATH" &
    echo "$!" >"$PIDPATH"
    echo "$VIDPATH" >"$RESOURCEPATH"
    notify-send "Start recording" "$VIDPATH"
    readonly PID="$(cat $PIDPATH)"
    wait "$PID"
    readonly VIDPATH="$(cat $RESOURCEPATH)"
    if [ ! -f "$VIDPATH" ]; then
      notify-send "Recording aborted"
    else
      #readonly OUTPUT="$(fb "$VIDPATH")"
      notify-send "Video saved" "$OUTPUT"
    fi
    rm "$PIDPATH"
    rm "$RESOURCEPATH"
  ) &
else
  readonly PID="$(cat $PIDPATH)"
  kill -SIGINT "$PID"
fi

#! /usr/bin/env bash
ACTIVEWINDOW=$(xdotool getactivewindow) 
if [ $? -eq 0 ]; then
  WINDOW=$(echo $(xwininfo -id $ACTIVEWINDOW -stats | egrep '(Width|Height):' | awk '{print $NF}') | sed -e 's/ /x/')
fi

if [ "$WINDOW" == "$1x1080" ]; then
  exit 0
fi
exit 1

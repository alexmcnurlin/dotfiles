
#!/bin/bash
while true; do
  ACTIVEWINDOW=$(xdotool getactivewindow)
  WINDOW=$(echo $(xwininfo -id $ACTIVEWINDOW -stats | egrep '(Width|Height):' | awk '{print $NF}') | sed -e 's/ /x/')
  if [ "$WINDOW" != $1"x1080" ]; then
    exit 0;
  fi
  sleep 1
done

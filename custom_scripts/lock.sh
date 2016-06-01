#!/bin/bash
#ICON=/usr/share/icons/Paper/512x512/apps/system-lock-screen.png
#I didn't write this. I found it somewhere on Reddit or Stackoverflow and 
#  adjusted it to fit my needs.
TMPBG=/tmp/screen.png
scrot /tmp/screen.png
convert $TMPBG -scale 5% -scale 2000% $TMPBG
playerctl pause # This will pause the music playing
#convert $TMPBG $ICON --composite -matte $TMPBG
#i3lock -u -i $TMPBG
i3lock -i $TMPBG

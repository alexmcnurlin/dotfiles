#!/usr/bin/env zsh
ICON=/usr/share/icons/Paper/512x512/apps/system-lock-screen.png
#I didn't write this. I found it somewhere on Reddit or Stackoverflow and 
#  adjusted it to fit my needs.
TMPBG=/tmp/screen.png
maim /tmp/screen.png
scale_factor=90
convert $TMPBG -scale $( qalc -t "$scale_factor/1080*100" )% -scale $( qalc -t "1080/$scale_factor*100" )% $TMPBG
playerctl pause # This will pause the music playing
#convert $TMPBG $ICON --composite -matte $TMPBG
#i3lock -u -i $TMPBG
~/Misc/Packages/i3lock-blur/i3lock $ICON -i $TMPBG

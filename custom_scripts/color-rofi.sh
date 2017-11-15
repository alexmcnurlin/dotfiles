#! /usr/bin/env bash

bgcolor=$1
fgcolor=$2
accent=$3
white=$4
bdcolor=$5
inner_gap=$6
outer_gap=$7
bar_height=$8
border_width=$9

if [ -e ~/.Xresources ]; then
	 sed -e "s/\(rofi.color-window: \)[#, 0-9a-fA-F]\{25\}/\1#$bgcolor, #$bgcolor, #$bgcolor/g" -i ~/.Xresources
	 sed -e "s/\(rofi.color-normal: \)[#, 0-9a-fA-F]\{43\}/\1#$bgcolor, #$fgcolor, #$bgcolor, #$fgcolor, #$bgcolor/g" -i ~/.Xresources
	 sed -e "s/\(rofi.color-active: \)[#, 0-9a-fA-F]\{43\}/\1#$fgcolor, #$bgcolor, #$fgcolor, #$bgcolor, #$bgcolor/g" -i ~/.Xresources
	 sed -e "s/\(rofi.color-urgent: \)[#, 0-9a-fA-F]\{43\}/\1#$bgcolor, #$bgcolor, #$bgcolor, #$bgcolor, #$bgcolor/g" -i ~/.Xresources
fi

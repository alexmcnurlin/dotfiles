#!/usr/bin/env bash

bgcolor=$1
fgcolor=$2
accent=$3
white=$4
bdcolor=$5
bar_height=$6
border_width=$7

myfile=~/.local/share/Steam/skins/Metro\ for\ Steam\ 4.2.3/custom.styles
if [ -e "$myfile" ]; then
  sed -e "s/\(Focus=\"\)[0-9]\{1,3\} [0-9]\{1,3\} [0-9]\{1,3\}\( 255\"\)/\1$(hexrgb $fgcolor)\2/g" -i "$myfile"
  # Focus_T="0 114 198 30.6"
fi

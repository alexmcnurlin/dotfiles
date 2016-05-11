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

nofity-send "$@"
sed -e "s/\(geometry = \"[[:digit:]]*x[[:digit:]]*\).*\"/\1-$(( outer_gap + inner_gap ))+$(( outer_gap + bar_height + inner_gap ))\"/" -i ~/.dotfiles/dunst/dunstrc

sed -e "s/\(background = \"#\)[0-9a-fA-F]\{6\}\(\" # low\)/\1$bgcolor\2/g" -i ~/.dotfiles/dunst/dunstrc
sed -e "s/\(foreground = \"#\)[0-9a-fA-F]\{6\}\(\" # low\)/\1$white\2/g" -i ~/.dotfiles/dunst/dunstrc
sed -e "s/\(background = \"#\)[0-9a-fA-F]\{6\}\(\" # normal\)/\1$white\2/g" -i ~/.dotfiles/dunst/dunstrc
sed -e "s/\(foreground = \"#\)[0-9a-fA-F]\{6\}\(\" # normal\)/\1$bgcolor\2/g" -i ~/.dotfiles/dunst/dunstrc
sed -e "s/\(background = \"#\)[0-9a-fA-F]\{6\}\(\" # critical\)/\1$bdcolor\2/g" -i ~/.dotfiles/dunst/dunstrc
sed -e "s/\(foreground = \"#\)[0-9a-fA-F]\{6\}\(\" # critical\)/\1$white\2/g" -i ~/.dotfiles/dunst/dunstrc

sed -e "s/\(-bc \"#\)[0-9a-fA-F]\{6\}/\1$bgcolor/g" -i ~/Misc/custom-scripts/rofi-dmenu
sed -e "s/\(-bg \"#\)[0-9a-fA-F]\{6\}/\1$bgcolor/g" -i ~/Misc/custom-scripts/rofi-dmenu
sed -e "s/\(-fg \"#\)[0-9a-fA-F]\{6\}/\1$fgcolor/g" -i ~/Misc/custom-scripts/rofi-dmenu
sed -e "s/\(-hlbg \"#\)[0-9a-fA-F]\{6\}/\1$fgcolor/g" -i ~/Misc/custom-scripts/rofi-dmenu
sed -e "s/\(-hlfg \"#\)[0-9a-fA-F]\{6\}/\1$bgcolor/g" -i ~/Misc/custom-scripts/rofi-dmenu

sed -e "s/\(separator_height = \)[[:digit:]]/\1$border_width/g" -i ~/.dotfiles/dunst/dunstrc
sed -e "s/\(separator_color = \"#\)[0-9a-fA-F]\{6\}\(\"\)/\1$fgcolor\2/g" -i ~/.dotfiles/dunst/dunstrc
#sed -e "s/\(separator_color = \)\"#[[:digit:]]*\"/\1\"#$fgcolor\"/" -i ~/.dotfiles/dunst/dunstrc

#! /usr/bin/env bash

bgcolor=$1
fgcolor=$2
accent=$3
white=$4
inner_gap=$5
outer_gap=$6
bar_height=$7

nofity-send "$@"
sed -e "s/\(geometry = \"[[:digit:]]*x[[:digit:]]*\).*\"/\1-$(( outer_gap + inner_gap ))+$(( outer_gap + bar_height + inner_gap ))\"/" -i ~/.dotfiles/dunst/dunstrc
#sed -e "s/\(separator_color = \)\"#[[:digit:]]*\"/\1\"#$fgcolor\"/" -i ~/.dotfiles/dunst/dunstrc

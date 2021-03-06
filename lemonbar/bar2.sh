#! /usr/bin/env bash
monitor1_width=$1
monitor1_output=$2
monitor2_width=$3
monitor2_output=$4
outer_gap=$5
inner_gap=$6
bar_height=$7
border_width=$8
font_size=$(( $bar_height * 4 / 10 ))
bgcolor=${16}$9
fgcolor=${10}
accent=${11}
gdcolor=${12}
degcolor=${13}
bdcolor=${14}


while true; do

	~/.dotfiles/lemonbar/lemonbar_status.py $bgcolor $fgcolor $accent $gdcolor $degcolor $bdcolor $monitor2_width $monitor2_output | lemonbar -d -g $(( monitor2_width - 2*outer_gap - 2*inner_gap ))x$bar_height+$(( monitor1_width + outer_gap + inner_gap ))+$(( outer_gap + inner_gap )) -B "#$bgcolor" -F "#FF$fgcolor" -U "#$fgcolor" -f "Liberation Mono for Powerline:style=Regular:size=$font_size" -f "FontAwesome:style=Regular:size=$font_size" -u $border_width

	~/.dotfiles/lemonbar/show_lemonbar.py

done

#! /usr/bin/env bash
transparency="c8"
monitor1=$1
monitor2=$2
outer_gap=$3
inner_gap=$4
bar_height=$5
border_width=$6
font_size=$(( $bar_height * 4 / 10 ))
bgcolor=$transparency$7
fgcolor=$8
accent=$9
gdcolor=${10}
degcolor=${11}
bdcolor=${12}

pkill lemonbar

# This is an invisible bar that makes the tiled windows move out of the way for the actual bar
echo " " | lemonbar -p -g 2x$(( bar_height + outer_gap ))+$(( monitor1 )) -B "#00000000" &
echo " " | lemonbar -p -g 2x$(( bar_height + outer_gap )) -B "#00000000" &

# Geometry is {width-2(outer_gap)}x{bar_height}+{offset+outer_gap}+{outer_gap}
# The bar for the left monitor (monitor1)
~/.dotfiles/lemonbar/lemonbar_status.sh $bgcolor $fgcolor $accent $gdcolor $degcolor $bdcolor | lemonbar -d -g $(( monitor1 - 2*outer_gap - 2*inner_gap + 2 ))x$bar_height+$(( outer_gap + inner_gap -1 ))+$(( outer_gap + inner_gap )) -B "#$bgcolor" -F "#FF$fgcolor" -p -f "Liberation Mono for Powerline:style=Regular:size=$font_size" -f "FontAwesome:style=Regular:size=$font_size" -u $border_width &

# The bar for the right monitor (monitor2)
~/.dotfiles/lemonbar/lemonbar_status.sh $bgcolor $fgcolor $accent $gdcolor $degcolor $bdcolor | lemonbar -d -g $(( monitor2 - 2*outer_gap - 2*inner_gap + 2 ))x$bar_height+$(( monitor1 + outer_gap + inner_gap -1 ))+$(( outer_gap + inner_gap )) -B "#$bgcolor" -F "#FF$fgcolor" -U "#$fgcolor" -p -f "Liberation Mono for Powerline:style=Regular:size=$font_size" -f "FontAwesome:style=Regular:size=$font_size" -u $border_width
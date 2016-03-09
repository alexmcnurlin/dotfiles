#! /usr/bin/env bash
monitor1=$1
monitor2=$2
outer_gap=$3
inner_gap=$4
bar_height=$5

notify-send -a "test" "$1 $2 $3 $4 $5 $(( monitor1 - 2*outer_gap - 2*inner_gap ))";
pkill lemonbar
echo  | lemonbar -p -g $(( monitor1 + 1 ))x$(( bar_height + outer_gap )) &
# Geometry is {width-2(outer_gap)}x{bar_height}+{offset+outer_gap}+{outer_gap}
~/.dotfiles/lemonbar/lemonbar_status.sh | lemonbar -d -g $(( monitor1 - 2*outer_gap - 2*inner_gap ))x$bar_height+$(( outer_gap + inner_gap ))+$(( outer_gap + inner_gap )) -B "#88FFFFFF" -F "#FF000000" -p -f FontAwesome:style=Regular &
~/.dotfiles/lemonbar/lemonbar_status.sh | lemonbar -d -g $(( monitor2 - 2*outer_gap - 2*inner_gap ))x$bar_height+$(( monitor1 + outer_gap + inner_gap ))+$(( outer_gap + inner_gap )) -B "#88FFFFFF" -F "#FF000000" -p -f FontAwesome:style=Regular

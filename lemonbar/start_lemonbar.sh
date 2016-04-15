#! /usr/bin/env bash
transparency="c8"
monitor1_width=$1
monitor1_output=$2
monitor2_width=$3
monitor2_output=$4
outer_gap=$5
inner_gap=$6
bar_height=$7
border_width=$8
font_size=$(( $bar_height * 4 / 10 ))
bgcolor=$transparency$9
fgcolor=${10}
accent=${11}
gdcolor=${12}
degcolor=${13}
bdcolor=${14}

# Kill the previous bar and all its subsidiaries
pkill lemonbar
kill -9 $(ps -aux | grep bar1.sh | grep -v grep | awk '{print $2}')
kill -9 $(ps -aux | grep bar2.sh | grep -v grep | awk '{print $2}')
kill -9 $(ps -aux | grep lemonbar_status.py | grep -v grep | awk '{print $2}')
kill -9 $(ps -aux | grep read_conky.sh | grep -v grep | awk '{print $2}')
kill -9 $(ps -aux | grep show_lemonbar.sh | grep -v grep | awk '{print $2}')

# This is an invisible bar that makes the tiled windows move out of the way for the actual bar
echo " " | lemonbar -p -g 2x$(( bar_height + outer_gap )) -B "#00000000" &
echo " " | lemonbar -p -g 2x$(( bar_height + outer_gap ))+$(( monitor1_width )) -B "#00000000" &

~/.dotfiles/lemonbar/read_conky.sh &

# Geometry is {width-2(outer_gap)}x{bar_height}+{offset+outer_gap}+{outer_gap}
# The bar for the left monitor (monitor1)
~/.dotfiles/lemonbar/bar1.sh $@ &

# The bar for the right monitor (monitor2)
~/.dotfiles/lemonbar/bar2.sh $@ &

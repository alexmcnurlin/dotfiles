#! /usr/bin/env bash

# TODO: 
#   * Fix Ethernet script
#   * Add Battery, CPU usage, CPU Temp, Disk usage (maybe)
#   * Hide bar on fullscreen
#       - Refer to ~/Misc/Packages/i3config-blueStag/home/kelaun/Scripts/hide_lemonbar.sh
#   * Only show workspaces on current monitor
#   * Pick Colorscheme

bgcolor=$1
fgcolor=$2
accent=$3
gdcolor=$4
degcolor=$5
bdcolor=$6

sep=" "
# The %{O} tags offset the text by a pixel. May need tweaking with some fonts
# Powerline format:
# "%{F$background_color}$sep%{B$foreground_color}%{R}Text here"

workspaces() {
    get_workspaces=$(i3-msg -t get_workspaces | jq -r 'map(.name) | .[]')
    current_workspace=$(i3-msg -t get_workspaces | jq -r 'map(select(.focused))[0].name')
    
     Leave this blank
    output=""
     This is the character used to separate workspace icons
    sep=" "

    for workspace in $get_workspaces; do
      if [ "$workspace" = "$current_workspace" ]; then
        output+="%{F#$accent+u}%{U#$accent} $workspace %{F!u}"
      else
        output+="%{-u} $workspace "
      fi
    done

    echo $output
}

wifi() {
  if [ $6 -lt 50 ]; then
    color=$5
  elif [ $6 -lt 75 ]; then
    color=$4
  else
    color=$3
  fi
  echo "%{F#$color+u}%{U#$color} $7: $6% IP:$8 %{F!u}"
}

# The update interval is controlled through the conky update interval
conky -c ~/.dotfiles/lemonbar/conkyrc | while read line; do
  output=($line)
  #notify-send "${output[*]}"
  workspaces=$(workspaces $bgcolor $fgcolor $accent $gdcolor $degcolor $bdcolor)
  wifi="$(wifi $fgcolor $bgcolor $gdcolor $degcolor $bdcolor ${output[1]} ${output[2]} ${output[3]})"
  #" %essid:%quality, IP:%ip"
  time="${output[0]} "
  echo "%{l}$workspaces %{r}$wifi $time"
  #echo "%{l}$(workspaces $bgcolor $fgcolor $accent $gdcolor $degcolor $bdcolor)%{r}$(eth)$(wifi $bgcolor $fgcolor $accent $gdcolor $degcolor $bdcolor)$(the_time)"
done

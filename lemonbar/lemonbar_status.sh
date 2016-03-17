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

workspaces() {
    get_workspaces=$(i3-msg -t get_workspaces | jq -r 'map(.name) | .[]')
    current_workspace=$(i3-msg -t get_workspaces | jq -r 'map(select(.focused))[0].name')
    
     #Leave this blank
    declare -a output

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
  if [ $6 != "No Address" ]; then
    if [ $4 -lt 50 ]; then
      color=$3
    elif [ $4 -lt 75 ]; then
      color=$2
    else
      color=$1
    fi
    echo "%{F#$color+u}%{U#$color}  $5: $4% IP:$6 %{F!u}"
  else
    echo "%{F#$3+u}%{U#$3}  No Wifi %{F!u}"
  fi;
}

cpu() {
  if [ $4 -gt 50 ]; then
    color=$3
  elif [ $4 -gt 20 ]; then
    color=$2
  else
    color=$1
  fi
  echo "%{F#$color+u}%{U#$color}  $4% %{F!u}"
}

temp() {
  if [ $4 -lt 75 ]; then
    color=$1
  elif [ $4 -lt 90 ]; then
    color=$2
  else 
    color=$3
  fi
  echo "%{F#$color+u}%{U#$color} $4°C %{F!u}"
}

# The update interval is controlled through the conky update interval
conky -c ~/.dotfiles/lemonbar/conkyrc | while read line; do
  IFS=';' read the_time wifi_percent wifi_essid wifi_ip cpu_percent cpu_temp <<< "$line"

  workspaces=$(workspaces $bgcolor $fgcolor $accent $gdcolor $degcolor $bdcolor)

  declare -a output
  output+="$(temp $gdcolor $degcolor $bdcolor $cpu_temp) "
  output+="$(cpu $gdcolor $degcolor $bdcolor $cpu_percent) "
  output+="$(wifi $gdcolor $degcolor $bdcolor $wifi_percent $wifi_essid $wifi_ip) "
  output+="%{U#$fgcolor+u} $the_time %{U!u} "

  echo "%{l}$workspaces %{r}${output[@]}"
  output=""
done

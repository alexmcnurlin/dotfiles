#! /usr/bin/env bash

# TODO: 
#   * Fix Ethernet script
#   * Add Battery, CPU usage, CPU Temp, Disk usage (maybe)
#   * Make Powerline Full height
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
sep="%{O}%{O-1}"
# The %{O} tags offset the text by a pixel. May need tweaking with some fonts
# Powerline format:
# "%{F$background_color}$sep%{B$foreground_color}%{R}Text here"


the_time() {
  date "+%%{F$bgcolor}$sep%%{B$fgcolor}%%{R} %a %D %T "
}

workspaces() {
    get_workspaces=$(i3-msg -t get_workspaces | jq -r 'map(.name) | .[]')
    current_workspace=$(i3-msg -t get_workspaces | jq -r 'map(select(.focused))[0].name')
    
    # Leave this blank
    output=""
    # This is the character used to separate workspace icons
    sep=" "

    for workspace in $get_workspaces; do
      if [ "$workspace" = "$current_workspace" ]; then
        output+="%{R} $workspace %{R}"
      else
        output+="%{R}%{R} $workspace "
      fi
    done

    echo $output
}

wifi() {
  # A beautiful mess of grep. Good luck changing this later
  stat=$(iwconfig wlan0)
  essid=$(echo $stat | grep -oP "(?<=ESSID:\").*?(?=\")")
  percent=$(qalc -t "$(echo $stat | grep -oP "(\d+/\d+)") * 100" | grep -oP "^(\d\d\d?$)|(.*?(?=\.))")
  ip=$(ifconfig wlan0 | grep -oP "(?<=inet addr:).*?\s")

  if [ $percent -lt 50 ]; then
    color="#$4";
  elif [ $percent -lt 75 ]; then
    color="#$5";
  else
    color="#$6";
  fi

  if [ $(echo $stat | grep -oP "ESSID:off/any") ]; then
    echo  No wireless;
    exit 0;
  elif [ "$ip" = "" ]; then
    ip="No IP";
    color="#$2";
  else 
    ip="IP:$ip";
  fi;

  echo "%{F$color}$sep%{R}  $essid: $percent% $ip"
}


eth() {
  status=$(/usr/share/i3blocks/network | head -1)
  if [ $status != "down" ]; then
    echo " Eth: $status";
  else
    echo "";
  fi;
}

while [ 1 ]; do
  echo "%{l}$(workspaces $bgcolor $fgcolor $accent $gdcolor $degcolor $bdcolor)%{r}$(eth)$(wifi $bgcolor $fgcolor $accent $gdcolor $degcolor $bdcolor)$(the_time)%{B}%{F}"
  sleep .5;
done

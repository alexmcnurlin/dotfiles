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
    
     #Leave this blank
    output=""

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
  if [ $4 -lt 50 ]; then
    color=$3
  elif [ $4 -lt 75 ]; then
    color=$2
  else
    color=$1
  fi
  echo "%{F#$color+u}%{U#$color}  $5: $4% IP:$6 %{F!u}"
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

power() {
  if [ "$5" == "on-line" ]; then
    if [ $6 == 0 ]; then
      echo "%{U#$4+u}  -- %{U}%{-u}"
    else
      echo "%{U#$1 F#$1+u}  $6% %{UF}%{-u}"
    fi
  else
    if [ $6 -lt 20 ]; then
      icon=
    elif [ $6 -lt 40 ]; then
      icon=
    elif [ $6 -lt 60 ]; then
      icon=
    elif [ $6 -lt 80 ]; then
      icon=
    else
      icon=
    fi

    if [ $6 -lt 35 ]; then
      color=$3
    elif [ $6 -lt 65 ]; then
      color=$2
    else 
      color=$1
    fi
      echo "%{U#$color F#$color+u} $icon $6% %{UF}%{-u}"
  fi
}

volume() {
  vol=$(pactl list sinks | perl -000ne 'if(/#1/){/(\d*(?=%))/; print "$1\n"}')

  if [ $vol -eq 0 ]; then
    icon=;
  elif [ $vol -lt 50 ]; then
    icon=;
  else
    icon=
  fi;

  mute=$(pacmd dump | awk ' $1 == "set-sink-mute" {m[$2] = $3}; $1 == "set-default-sink" {s = $2}; END {print m[s]}');

  if [ $mute = "yes" ]; then
    echo "%{U#$2 F#$2+u} muted($vol%) %{UF}%{-u}";
  else
    echo "%{U#$1 F#$1+u} $icon $vol% %{UF}%{-u}";
  fi;
}

# The update interval is controlled through the conky update interval
conky -c ~/.dotfiles/lemonbar/conkyrc | while read line; do
  the_output=($line)
  output=("${the_output[@]//\"/}")

  workspaces=$(workspaces $bgcolor $fgcolor $accent $gdcolor $degcolor $bdcolor)

  temp="$(temp $gdcolor $degcolor $bdcolor ${output[5]})"
  cpu="$(cpu $gdcolor $degcolor $bdcolor ${output[4]})"
  wifi="$(wifi $gdcolor $degcolor $bdcolor ${output[1]} ${output[2]} ${output[3]})"
  time="${output[0]}"

  echo "%{l}$workspaces %{r}${output[@]}"
  output=""

  if $(~/.dotfiles/lemonbar/hide_lemonbar.sh); then
    exit 0
  fi;
done

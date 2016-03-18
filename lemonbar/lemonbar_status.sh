#! /usr/bin/env bash

# TODO: 
#   * Add Battery, CPU usage, CPU Temp, Disk usage (maybe)
#   * Hide bar on fullscreen
#       - Refer to ~/Misc/Packages/i3config-blueStag/home/kelaun/Scripts/hide_lemonbar.sh
#   * Only show workspaces on current monitor

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

eth() {
  if [ $3 != "No Address" ]; then
    echo "%{F#$1+u}%{U#$1} Eth: $3 %{F!u}"
  else
    echo "%{F#$2+u}%{U#$2} No Eth %{F!u}"
  fi
}

wifi() {
  if [ $7 != "No Address" ]; then
    if [ $5 -lt 50 ]; then
      color=$3
    elif [ $5 -lt 75 ]; then
      color=$2
    else
      color=$1
    fi
    echo "%{F#$color+u}%{U#$color}  $6: $5% IP:$7 %{F!u}"
  else
    echo "%{F#$4+u}%{U#$4}  No Wifi %{F!u}"
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
    echo "%{U#$2F#$2+u} muted($vol) %{UF}%{-u}";
  else
    echo "%{U#$1 F#$1+u} $icon $vol %{UF}%{-u}";
  fi;
}

# The update interval is controlled through the conky update interval
conky -c ~/.dotfiles/lemonbar/conkyrc | while read line; do
  IFS=';' read the_time wifi_percent wifi_essid wifi_ip eth_ip cpu_percent cpu_temp ac bat <<< "$line"

  workspaces=$(workspaces $bgcolor $fgcolor $accent $gdcolor $degcolor $bdcolor)

  declare -a output
  output+="$(volume $fgcolor $degcolor) "
  output+="$(temp   $gdcolor $degcolor $bdcolor $cpu_temp) "
  output+="$(cpu    $gdcolor $degcolor $bdcolor $cpu_percent) "
  output+="$(eth    $fgcolor $bdcolor "$eth_ip") "
  output+="$(wifi   $gdcolor $degcolor $bdcolor $fgcolor $wifi_percent $wifi_essid "$wifi_ip") "
  output+="$(power  $gdcolor $degcolor $bdcolor $fgcolor $ac $bat) "
  output+="%{U#$fgcolor+u} $the_time %{U!u} "

  echo "%{l}$workspaces %{r}${output[@]}"
  output=""
done

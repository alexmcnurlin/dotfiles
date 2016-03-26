#! /usr/bin/env python3

import i3ipc
from subprocess import call
import subprocess as sub
import sys

# TODO: 
#   * Add Battery, CPU usage, CPU Temp, Disk usage (maybe)
#   * Hide bar on fullscreen
#       - Refer to ~/Misc/Packages/i3config-blueStag/home/kelaun/Scripts/hide_lemonbar.sh
#   * Only show workspaces on current monitor

bgcolor = sys.argv[1]
fgcolor = sys.argv[2]
accent  = sys.argv[3]
gdcolor = sys.argv[4]
degcolor= sys.argv[5]
bdcolor = sys.argv[6]

sep=" "


def workspaces( bgcolor, fgcolor, accent, gdcolor, degcolor, bdcolor ):
    temp = sub.Popen("i3-msg -t get_workspaces | jq -r 'map(.name) | .[]'", stdout=sub.PIPE, shell=True)
    get_workspaces = temp.communicate()[0].decode("utf-8").replace("\n","")

    temp = sub.Popen("i3-msg -t get_workspaces | jq -r 'map(select(.focused))[0].name'", stdout=sub.PIPE, shell=True)
    current_workspace = temp.communicate()[0].decode("utf-8").strip()
    
     #Leave this blank
    output = []

    for workspace in get_workspaces:
      if ( workspace == current_workspace ):
        output.append("%{{U#{0} F#{0}+u}} {1} %{{F!u}}".format( accent, workspace ) )
      else:
        output.append(" {0} ".format( workspace ))

    return("".join(output))


def eth( fgcolor, bdcolor, eth_ip ):
  if ( eth_ip != "No Address" ):
    return("%{{F#{0}+u}}%{{U#{0}}} Eth: {2} %{{F!u}}".format(fgcolor, bdcolor, eth_ip))
  else:
    return("%{{F#{1}+u}}%{{U#{1}}} No Eth %{{F!u}}".format(fgcolor, bdcolor, eth_ip))


def wifi( gdcolor, degcolor, bdcolor, fgcolor, wifi_percent, wifi_essid, wifi_ip ):
  if ( wifi_ip != "No Address" ):
    if ( int(wifi_percent) < 50 ):
      color=bdcolor
    elif ( int(wifi_percent) < 75 ):
      color=degcolor
    else:
      color=gdcolor
    return("%{{F#{0}+u}}%{{U#{0}}}  {2}: {1}% IP:{3} %{{F!u}}".format( color, wifi_percent, wifi_essid, wifi_ip ))
  else:
    return("%{{F#{0}+u}}%{{U#{0}}}  No Wifi %{{F!u}}".format( fgcolor, wifi_percent, wifi_essid, wifi_ip ))


def cpu( gdcolor, degcolor, bdcolor, cpu_percent ):
  if ( int(cpu_percent) > 50 ):
    color=bdcolor
  elif ( int(cpu_percent) > 20 ):
    color=degcolor
  else:
    color=gdcolor
  return("%{{F#{0}+u}}%{{U#{0}}}  {1}% %{{F!u}}".format( color, cpu_percent ))


def temp( gdcolor, degcolor, bdcolor, cpu_temp ):
  if ( int(cpu_temp) < 75 ):
    color=gdcolor
  elif ( int(cpu_temp) < 90 ):
    color=degcolor
  else:
    color=bdcolor
  return("%{{F#{0}+u}}%{{U#{0}}} {1}°C %{{F!u}}".format( color, cpu_temp ))


def power( gdcolor, degcolor, bdcolor, fgcolor, ac, bat ):
  if ( ac == "on-line" ):
    if ( int(bat) == 0 ):
      return("%{{U#{0}+u}}  -- %{{U}}%{{-u}}".format( fgcolor ))
    else:
      return("%{{U#{0} F#{0}+u}}  {1}% %{{UF}}%{{-u}}".format( gdcolor, bat ))
  else:
    if ( int(bat) < 20 ):
      icon=""
    elif ( int(bat) < 40 ):
      icon=""
    elif ( int(bat) < 60 ):
      icon=""
    elif ( int(bat) < 80 ):
      icon=""
    else:
      icon=""

    if ( int(bat) < 35 ):
      color=bdcolor
    elif ( int(bat) < 65 ):
      color=degcolor
    else:
      color=gdcolor
    return("%{{U#{0} F#{0}+u}} {1} {2}% %{{UF}}%{{-u}}".format( color, icon, bat ))


def volume( fgcolor, degcolor ):
  try:
    temp = sub.Popen("pactl list sinks | perl -000ne 'if(/#1/){/(\d*(?=%))/; print \"$1\"}'", stdout=sub.PIPE, shell=True)
    vol_b = temp.communicate()[0]
    vol = vol_b.decode("utf-8")
  except:
    sys.stderr.write("Error")


  if ( int(vol) == 0 ):
    icon=""
  elif ( int(vol) < 50 ):
    icon=""
  else:
    icon=""

  try:
     temp = sub.Popen("pacmd dump | awk ' $1 == \"set-sink-mute\" {m[$2] = $3}; $1 == \"set-default-sink\" {s = $2}; END {print m[s]}'", stdout=sub.PIPE, shell=True)
     mute = temp.communicate()[0]
  except:
    sys.stderr.write("Error in mute")
    mute = "no"

  if ( mute == "yes" ):
    return("%{{U#{0} F#{0}+u}} muted({1}%) %{{UF}}%{{-u}}".format( degcolor, vol ))
  else:
    return("%{{U#{0} F#{0}+u}} {2} {1}% %{{UF}}%{{-u}}".format( fgcolor, vol, icon ))

# The update interval is controlled through the conky update interval
#conky = subprocess.Popen("conky -c ~/.dotfiles/lemonbar/conkyrc")
for line in sys.stdin:
  conky = line.split(";")

  the_time     = conky.pop(0)
  wifi_percent = conky.pop(0)
  wifi_essid   = conky.pop(0)
  wifi_ip      = conky.pop(0)
  eth_ip       = conky.pop(0)
  cpu_percent  = conky.pop(0)
  cpu_temp     = conky.pop(0)
  ac           = conky.pop(0)
  bat          = conky.pop(0)

  desktops = workspaces( bgcolor, fgcolor, accent, gdcolor, degcolor, bdcolor )

  str_r_side = []
  r_side = []
  r_side.append( str( volume( fgcolor, degcolor )) )
  r_side.append( str( temp(   fgcolor, degcolor, bdcolor, cpu_temp )) )
  r_side.append( str( cpu(    fgcolor, degcolor, bdcolor, cpu_percent )) )
  r_side.append( str( eth(    fgcolor, bdcolor, eth_ip )) )
  r_side.append( str( wifi(   fgcolor, degcolor, bdcolor, fgcolor, wifi_percent, wifi_essid, wifi_ip )) )
  r_side.append( str( power(  fgcolor, degcolor, bdcolor, fgcolor, ac, bat )) )
  r_side.append( str("%{{U#{0}+u}} {1} %{{U!u}}".format( fgcolor, the_time )) )
  
  str_r_side = " ".join(r_side)

  print("%{{l}}{0} %{{r}}{1}".format( desktops, str_r_side ), flush=True)
done

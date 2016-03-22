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
    get_workspaces = temp.communicate()

    #get_workspaces=$(i3-msg -t get_workspaces | jq -r 'map(.name) | .[]')
    temp = sub.Popen("i3-msg -t get_workspaces | jq -r 'map(select(.focused))[0].name'", stdout=sub.PIPE, shell=True)
    current_workspace = temp.communicate()
    #current_workspace=$(i3-msg -t get_workspaces | jq -r 'map(select(.focused))[0].name')
    
     #Leave this blank
    output = []

    for workspace in get_workspaces:
      if ( workspace == current_workspace ):
        output.append("%{{F#{0}+u}}%{{U#{0}}} {1} %{{F!u}}".format( accent, workspace ) )
      else:
        output.append("%{{-u}} {0} ".format( workspace ))

    print(output)


def eth( fgcolor, bdcolor, eth_ip ):
  if ( eth_ip != "No Address" ):
    print("%{{F#{0}+u}}%{{U#{0}}} Eth: {2} %{{F!u}}".format(fgcolor, bdcolor, eth_ip))
  else:
    print("%{{F#{1}+u}}%{{U#{1}}} No Eth %{{F!u}}".format(fgcolor, bdcolor, eth_ip))


def wifi( gdcolor, degcolor, bdcolor, fgcolor, wifi_percent, wifi_essid, wifi_ip ):
  if ( wifi_ip != "No Address" ):
    if ( int(wifi_percent) < 50 ):
      color=bdcolor
    elif ( int(wifi_percent) < 75 ):
      color=degcolor
    else:
      color=gdcolor
    print("%{{F#{0}+u}}%{{U#{0}}}  {2}: {1}% IP:{3} %{{F!u}}".format( color, wifi_percent, wifi_essid, wifi_ip ))
  else:
    print("%{{F#{0}+u}}%{{U#{0}}}  No Wifi %{{F!u}}".format( fgcolor, wifi_percent, wifi_essid, wifi_ip ))
    #echo "%{F#$4+u}%{U#$4}  No Wifi %{F!u}"


def cpu( gdcolor, degcolor, bdcolor, cpu_percent ):
  if ( int(cpu_percent) > 50 ):
    color=bdcolor
  elif ( int(cpu_percent) > 20 ):
    color=degcolor
  else:
    color=gdcolor
  print("%{{F#{0}+u}}%{{U#{0}}}  {1}% %{{F!u}}".format( color, cpu_percent ))


def temp( gdcolor, degcolor, bdcolor, cpu_temp ):
  if ( int(cpu_temp) < 75 ):
    color=gdcolor
  elif ( int(cpu_temp) < 90 ):
    color=degcolor
  else:
    color=bdcolor
  print("%{{F#{0}+u}}%{{U#{0}}} {1}°C %{{F!u}}".format( color, cpu_temp ))


def power( gdcolor, degcolor, bdcolor, fgcolor, ac, bat ):
  #sys.stderr.write("Ac == " + ac)
  if ( ac == "on-line" ):
    if ( int(bat) == 0 ):
      print("%{{U#{0}+u}}  -- %{{U}}%{{-u}}".format( fgcolor ))
    else:
      print("%{{U#{0} F#{0}+u}}  {1}% %{{UF}}%{{-u}}".format( gdcolor, bat ))
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
    print("%{{U#{0} F#{0}+u}} {1} {2}% %{{UF}}%{{-u}}".format( color, icon, bat ))


def volume( fgcolor, degcolor ):
  vol = call("pactl list sinks | perl -000ne 'if(/#1/){/(\d*(?=%))/; print \"$1\n\"}'", shell=True)

  if ( int(vol) == 0 ):
    icon=""
  elif ( int(vol) < 50 ):
    icon=""
  else:
    icon=""

  mute = call( "pacmd dump | awk ' $1 == \"set-sink-mute\" {m[$2] = $3}; $1 == \"set-default-sink\" {s = $2}; END {print m[s]}'", shell=True )

  if ( mute == "yes" ):
    print("%{{U#{0} F#{0}+u}} muted({1}%) %{{UF}}%{{-u}}".format( degcolor, vol ))
  else:
    print("%{{U#{0} F#{0}+u}} {2} {1}% %{{UF}}%{{-u}}".format( fgcolor, vol, icon ))

# The update interval is controlled through the conky update interval
#conky = subprocess.Popen("conky -c ~/.dotfiles/lemonbar/conkyrc")
for line in sys.stdin:
  #line = conky.stdout.read()
  output = line.split(";")

  for i in output:
    sys.stderr.write(i + ", ")

  the_time     = line[0]
  wifi_percent = line[1]
  wifi_essid   = line[2]
  wifi_ip      = line[3]
  eth_ip       = line[4]
  cpu_percent  = line[5]
  cpu_temp     = line[6]
  ac           = line[7]
  bat          = line[8]

  #workspaces=$(workspaces $bgcolor $fgcolor $accent $gdcolor $degcolor $bdcolor)
  desktops = workspaces( bgcolor, fgcolor, accent, gdcolor, degcolor, bdcolor )

  output = []
  output.append( volume( fgcolor, degcolor ) )
  output.append( temp(   fgcolor, degcolor, bdcolor, cpu_temp ) )
  output.append( cpu(    fgcolor, degcolor, bdcolor, cpu_temp ) )
  output.append( eth(    fgcolor, degcolor, eth_ip ) )
  output.append( wifi(   fgcolor, degcolor, bdcolor, fgcolor, wifi_percent, wifi_essid, wifi_ip ) )
  output.append( power(  fgcolor, degcolor, bdcolor, fgcolor, ac, bat ) )
  output.append("%{{U#{0}+u}} {1} %{{U!u}}".format( fgcolor, the_time ))
  #output+="$(volume $fgcolor $degcolor) "
  #output+="$(temp   $gdcolor $degcolor $bdcolor $cpu_temp) "
  #output+="$(cpu    $gdcolor $degcolor $bdcolor $cpu_percent) "
  #output+="$(eth    $fgcolor $bdcolor "$eth_ip") "
  #output+="$(wifi   $gdcolor $degcolor $bdcolor $fgcolor $wifi_percent $wifi_essid "$wifi_ip") "
  #output+="$(power  $gdcolor $degcolor $bdcolor $fgcolor $ac $bat) "
  output+="%{{U#{0}+u}} {1} %{{U!u}} ".format( fgcolor, the_time )
  
  left_side = " ".join(output)

  call("notify-send 'hello " + left_side + "'", shell=True)
  print("%{{l}}{0} %{{r}}{1}".format( workspaces, left_side ))
  output = []

  result = call("~/.dotfiles/lemonbar/hide_lemonbar.sh")
  text = result.communicate()[0]
  returncode = result.returncode

  if returncode:
    sys.exit(0)
done

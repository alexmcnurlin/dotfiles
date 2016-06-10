#! /usr/bin/env python3

import i3ipc
from subprocess import call
import subprocess as sub
import sys
import multiprocessing
from time import sleep
import datetime

# TODO: 
#   * Hide bar on fullscreen
#       - Refer to ~/Misc/Packages/i3config-blueStag/home/kelaun/Scripts/hide_lemonbar.sh
#   * Only show workspaces on current monitor
#   * Fix volume script (it doesn't show if muted)
#   * Rewrite workspaces to use python + i3ipc, not bash
#   * Kill all processes created by the bar when i3 is restarted

# Parse arguments
bgcolor   = sys.argv[1]
fgcolor   = sys.argv[2]
accent    = sys.argv[3]
gdcolor   = sys.argv[4]
degcolor  = sys.argv[5]
bdcolor   = sys.argv[6]
x_monitor = sys.argv[8]

# Make connection with i3 ipc socket
i3 = i3ipc.Connection()

logfile = open( '/home/alexmcnurlin/.dotfiles/lemonbar/log_lemonbar_status.txt', 'a+' )


def workspaces( bgcolor, fgcolor, accent, gdcolor, degcolor, bdcolor, i3, x_monitor ):
  # Gets the names of each workspace. This should be rewritten to use i3ipc
  temp = sub.Popen("i3-msg -t get_workspaces | jq -r 'map(.name) | .[]'", stdout=sub.PIPE, shell=True)
  get_workspaces = temp.communicate()[0].decode("utf-8").replace("\n","")

  temp = sub.Popen("i3-msg -t get_outputs | jq -r 'map(select(.active == true)) | map(select(.name == \"{0}\"))[0].current_workspace'".format( x_monitor ), stdout=sub.PIPE, shell=True)
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
  try:
    if ( int(cpu_temp) < 75 ):
      color=gdcolor
    elif ( int(cpu_temp) < 90 ):
      color=degcolor
    else:
      color=bdcolor
    return("%{{F#{0}+u}}%{{U#{0}}} {1}°C %{{F!u}}".format( color, cpu_temp ))
  except ValueError:
    return("%{{F#{0}+u}}%{{U#{0}}} {1} %{{F!u}}".format(bdcolor, "Error, temp not found"))


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
     temp1 = sub.Popen("pacmd dump | awk ' $1 == \"set-sink-mute\" {m[$2] = $3}; $1 == \"set-default-sink\" {s = $2}; END {print m[s]}'", stdout=sub.PIPE, shell=True)
     temp2 = temp1.communicate()[0]
     mute = temp2.decode("utf-8").strip()
  except AttributeError:
    mute = temp.strip()
  except:
    sys.stderr.write("Error in mute")
    mute = "no"

  if ( mute == "yes" ):
    return("%{{U#{0} F#{0}+u}} muted({1}%) %{{UF}}%{{-u}}".format( degcolor, vol ))
  else:
    return("%{{U#{0} F#{0}+u}} {2} {1}% %{{UF}}%{{-u}}".format( fgcolor, vol, icon ))


def du( fgcolor, disk_usage ):
  return("%{{U#{0} F#{0}+u}}  {1} %{{UF}}%{{-u}}".format( fgcolor, disk_usage ))





def update_bar(arg1, arg2):
  # Open file containing conky output
  iterable_line = open("/home/alexmcnurlin/.dotfiles/lemonbar/conky_output", "r")
  iterable_line.seek(0)
  line = iterable_line.readline()

  # Parse the results from conky
  conky = line.split(";")

  try:
    the_time     = conky.pop(0)
    wifi_percent = conky.pop(0)
    wifi_essid   = conky.pop(0)
    wifi_ip      = conky.pop(0)
    eth_ip       = conky.pop(0)
    cpu_percent  = conky.pop(0)
    cpu_temp     = conky.pop(0)
    ac           = conky.pop(0)
    bat          = conky.pop(0)
    disk_usage   = conky.pop(0)
  except IndexError:
    logfile.write( datetime.datetime.strftime(datetime.datetime.now(), '%Y-%m-%d %H:%M:%S') + " Conky input is empty!" + "\n" )
    return None


  # Get workspaces 
  # This would probably be more efficient with i3ipc
  desktops = workspaces( bgcolor, fgcolor, accent, gdcolor, degcolor, bdcolor, i3, x_monitor )

  str_r_side = []
  r_side = []
  # Construct the output from the conky output
  # Reorder these lines to change the order of output
  r_side.append( str( du(     fgcolor, disk_usage )) )
  r_side.append( str( volume( fgcolor, degcolor )) )
  r_side.append( str( temp(   gdcolor, degcolor, bdcolor, cpu_temp )) )
  r_side.append( str( cpu(    gdcolor, degcolor, bdcolor, cpu_percent )) )
  r_side.append( str( eth(    fgcolor, fgcolor, eth_ip )) )
  r_side.append( str( wifi(   fgcolor, degcolor, bdcolor, fgcolor, wifi_percent, wifi_essid, wifi_ip )) )
  r_side.append( str( power(  gdcolor, degcolor, bdcolor, fgcolor, ac, bat )) )
  r_side.append( str("%{{F#{0} U#{0}+u}} {1} %{{F U!u}}".format( gdcolor, the_time )) )
  
  str_r_side = " ".join(r_side)

  # Put together the output
  print("%{{l}}{0} %{{r}}{1}".format( desktops, str_r_side ), flush=True)


def background_update_bar():
  #conky_output = open("/home/alexmcnurlin/.dotfiles/lemonbar/conky_output", "r")
  try:
    while True:
      update_bar("ignore_this", "ignore_this_too")
      sleep(1)
  except Exception as e:
    temp = logfile.write(datetime.datetime.strftime(datetime.datetime.now(), '%Y-%m-%d %H:%M:%S') + str(e) + "\n" )
    background_update_bar()


def hide_bar(self, e):
  if ( i3.get_tree().find_focused().fullscreen_mode == 1 ): 
    exit(0)




# Events that update the bar
i3.on('workspace::focus',        update_bar)
i3.on("window::focus",           update_bar)
i3.on("barconfig_update",        update_bar)
i3.on("window::fullscreen_mode", hide_bar)
i3.on('workspace::focus',        hide_bar)
i3.on("window::focus",           hide_bar)

# Output the status once before listening to events


update_bar("ignore_this", "ignore_this_too")
background_update = multiprocessing.Process(name='bg_update', target=background_update_bar)
background_update.daemon = True
background_update.start()

# Listen for events
i3.main()

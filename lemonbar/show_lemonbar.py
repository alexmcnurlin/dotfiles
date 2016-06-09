#!/usr/bin/env python3
import i3ipc
import sys

def show_bar(self, e):
  if ( i3.get_tree().find_focused().fullscreen_mode == 0 ): 
    exit(0)

i3 = i3ipc.Connection()

i3.on("window::fullscreen_mode", show_bar)
i3.on('workspace::focus', show_bar)
i3.on("window::focus", show_bar)

i3.main()

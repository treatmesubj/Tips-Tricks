#!/bin/bash

# add this to /etc/rc.local to launch tmux session at boot: sudo -u pi bash /home/pi/Documents/Tips-Tricks/Raspberry_Pi_Stuff/tmux_launch.sh &
tmux new-session -d -s tmuxsesh -c ~
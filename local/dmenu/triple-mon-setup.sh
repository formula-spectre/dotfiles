#!/bin/zsh

sh ~/.screenlayout/triple-mon.sh

killall polybar
polybar bspwmbar-monitor3
polybar bspwmbar-monitor
setxkbmap de
killall sxhkd
sxhkd &
wal -i ~/Pictures/Walls/ --iteractive

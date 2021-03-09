#!/bin/sh
#artix file
function run {
  if ! pgrep $1 ;
  then
    $@&
  fi
}


#$HOME/.config/polybar/launch.sh &
nm-applet &
volumeicon &
kdeconnect-indicator &
syncthing-gtk -m &
dunst &
lxpolkit &
keepassxc &
tutanota-desktop &
blueman-applet &
birdtray &
picom &
xfsettingsd &
flameshot &
xfce4-clipman &
redshift-gtk &
start-pulseaudio-x11
sxhkd &

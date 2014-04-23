#!/bin/bash

# bash so we can use stuff like declare

#xsetroot
# Set background
BACKGROUND="/home/taylor/Pictures/backgrounds/nightfall_skyline-wallpaper-2560x1440.jpg"
if [ -n "$BACKGROUND" ] ; then
  if [ -x `which feh` ] ; then
    if [ -f $HOME/.fehbg ] ; then
      sh $HOME/.fehbg
      (sleep 60 ; sh $HOME/.fehbg ) &
    else
      feh  --image-bg black --bg-center "$BACKGROUND"
    fi
  elif [ -x `which qiv` ] ; then
    qiv -z "$BACKGROUND"
  elif [ -x `which awsetbg` ] ; then
    awsetbg "$BACKGROUND"
  fi
elif [ -x `which xsetroot` ] ; then
  xsetroot -solid black
fi

OS=`uname -s`

if [ -f "/sys/class/dmi/id/product_name" ] ; then
  PRODNAME=$(cat /sys/class/dmi/id/product_name)
fi

[[ -f "$HOME/.xmodmap" ]] &&
  xmodmap $HOME/.xmodmap

#if [ -f `which xcompmgr` ] ; then
#  xcompmgr -fF -I-.002 -O-.003 -D1 &
#fi

#if [ "$OS" = "Darwin" ] ; then
#quartz-wm --only-proxy &
#~/sw/bin/autocutsel &
#fi

# Load the .Xdefaults (same as .Xresources) file
[[ -f $HOME/.Xdefaults ]] &&
  xrdb -merge $HOME/.Xdefaults
  #xrdb -l $HOME/.Xdefaults

XMSG="xmessage"
XMSGOPTS="-buttons OK:0 -default OK"
mymsg() {
  if [ "$1" = "x" ] ; then
    shift
    $XMSG $XMSGOPTS $* &
  else
    notify-send "$*" &
  fi
}

msgqi=0
declare -a MSGQ

addmsg() {
  echo "adding msg $* at slot $msgqi"
  MSGQ[$msgqi]="$*"
  msgqi=$(( $msgqi+1 ))
}

showmsgs() {
  i=0
  n=${#MSGQ[@]}
  while [ ! $i = $n ] ; do
    mymsg ${MSGQ[$i]}
    i=$(( $i+1 ))
    sleep 3
  done
  unset MSGQ
  unset msgqi
}

#[ -x `which autocutsel` ] && autocutsel -selection PRIMARY &

addmsg "no more messages"

( 
sleep 5
showmsgs
) &

# See http://www.gnupg.org/documentation/manuals/gnupg/Invoking-GPG_002dAGENT.html
#echo "Starging gpg agent in daemon mode"
#gpg-agent --daemon --enable-ssh-support --write-env-file "${HOME}/.gpg-agent-info"
#eval $(gpg-agent --daemon)
#eval $(cat ${HOME}/.gpg-agent-info)
#ssh-agent -t $SAMAXTIME $WM

#brightside &
#wicd-gtk -t -a &
#( sleep 10 ; gnome-session ) &
disper -e
#gnome-session &
#exec awesome
#
# screen powersave
xset +dpms
xset dpms 0 0 300

eval `dbus-launch`

syndaemon -t -k -i 2 -d &

#xmodmap ~/.xmodmap &

xinput set-prop 9 "Evdev Middle Button Emulation" 1

mymsg "redshift starting"
redshiftgui &

# from https://awesome.naquadah.org/wiki/Quickly_Setting_up_Awesome_with_Gnome
#awesome &
#exec ck-launch-session gnome-session # ck-launch-session is advised for the dbus stuff to work fine.
#


#export OOO_FORCE_DESKTOP=gnome

#eval `gnome-keyring-daemon` &

#exec ck-launch-session gnome-session --session awesome "$@" 

notify-listener.py &

start-pulseaudio-x11 &
#pasystray &
pnmixer &

# Composite Manager
#unagi &
#cairo-compmgr &
#xcompmgr -cC &
#xcompmgr -c &


mymsg "Starting srandrd to auto handle screen layout with screen-layout and autorandr"
srandrd screen-layout auto &

mymsg "Starting xscreensaver"
xscreensaver -no-splash &
mymsg "Starting xautolock using lockscreen with 15min timer"
xautolock -locker lockscreen -time 15 &

[ ! -s ~/.config/mpd/pid ] && mpd &

exec awesome

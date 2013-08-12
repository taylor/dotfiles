#!/bin/bash

# bash so we can use stuff like declare

OLDPATH=$PATH
PATH=$HOME/sw/bin:/opt/bin:/bin:/usr/bin:/usr/local/bin:/usr/X11R6/bin:/usr/X11R6/bin/:/opt/pkg/sbin:/opt/pkg/bin

#xsetroot
# Set background
BACKGROUND="/home/taylor/Pictures/background/appleconquertheuniverse.png"
if [ -x `which qiv` ] ; then
  qiv -z "$BACKGROUND"
elif [ -x `which awsetbg` ] ; then
  awsetbg "$BACKGROUND"
elif [ -x `which xsetroot` ] ; then
  xsetroot -solid black
fi

OS=`uname -s`

if [ -f "/sys/class/dmi/id/product_name" ] ; then
  PRODNAME=$(cat /sys/class/dmi/id/product_name)
fi

if [ -f "$HOME/.xmodmap" ] ; then
  xmodmap $HOME/.xmodmap
fi

#if [ -f `which xcompmgr` ] ; then
#  xcompmgr -fF -I-.002 -O-.003 -D1 &
#fi




#if [ "$OS" = "Darwin" ] ; then
#quartz-wm --only-proxy &
#~/sw/bin/autocutsel &
#fi


# Load the .Xresources file
if [ -f $HOME/.Xresources ] ; then
  #xrdb -l $HOME/.Xresources
  xrdb -merge $HOME/.Xresources
fi

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


#x=`xmodmap |grep Caps_Lock && echo $?`
#if [ $? = 0 ] ; then
#  # since hal does not always work....
#  #xmodmap -e "clear Lock"
#  #xmodmap -e "keycode 66 = Control_L"
#  #mymsg x -timeout 2 "Making the Caps Lock key another Control key"
#  addmsg "Making the Caps Lock key another Control key"
#  xmodmap -e "remove lock = Caps_Lock"
#  xmodmap -e "add control = Caps_Lock"
#  xmodmap -e "keycode 66 = Control_L"
#fi


#if [ "${PRODNAME:0:7}" = "MacBook" -o "$PRODNAME" = "" ] ; then
  # Disable touch pad when typing
  # install the xorg-input-synaptics or use the following with SHMConfig on
  #syndaemon  -i 1 -S -d &
#  syndaemon -k -t -i 1 > /dev/null &
#fi


#[ -x `which autocutsel` ] && autocutsel -selection PRIMARY &

# setup gconf so you can use gnome apps w/o trouble
eval `/usr/bin/dbus-launch --sh-syntax --exit-with-session`
/usr/lib/libgconf2-4/gconfd-2 &

#pulse-session &

#eval `gnome-keyring-daemon`

# quake console term - press F5
#/usr/bin/tilda -h -t 50 &

#quartz-wm
#twm
#evilwm &


#( sleep  5 ; ssh-add ) &

if [ -x "`which ratpoison`" ] ; then
  WM=ratpoison
  # Only useful with ratpoison
  # Moved to .ratpoisonrc for now
  (
    sleep 2
    killall -TERM notification-daemon 2> /dev/null
    killall -TERM notify-osd 2> /dev/null
    sleep 1
    if [ `pidof notification-daemon` ] ; then
      killall -KILL notification-daemon 2> /dev/null
    elif [ `pidof notify-osd` ] ; then
      killall -KILL notify-osd 2> /dev/null
    fi
    $HOME/sw/bin/statnot &
#    $HOME/sw/bin/purple_rat.py &
    #xmessage "Your battery is funky... not starting ratatat" &
    #ratpoison -c "echo your battery is junk" &
    $HOME/sw/bin/ratatat.py &
  ) &
elif [ -x "`which x-terminal-emulator`" ] ; then
  WM=x-terminal-emulator
else
  WM=xterm
fi

gnomepm() {
  if [ "$1" = "quick" -o "$1" = "init" ] ; then
    addmsg "running gnome-power-manager with immediate exit option"
    gnome-power-manager --immediate-exit > /dev/null 2>&1
    if [ $? = 0 ] ; then
      touch /tmp/gnomepm-initialized
    fi
  else
    gnome-power-manager &
  fi
}

#gnomepm "quick"

#gnome-settings-daemon &
#gnome-volume-manager &

#WM=gnome-session

SAMAXTIME=12000
#ssh-agent -t $SAMAXTIME (ratpoison || x-terminal-emulator || xterm)


addmsg "no more messages"

( 
sleep 5
showmsgs
) &

#PATH=$OLDPATH



# See http://www.gnupg.org/documentation/manuals/gnupg/Invoking-GPG_002dAGENT.html
#echo "Starging gpg agent in daemon mode"
#gpg-agent --daemon --enable-ssh-support --write-env-file "${HOME}/.gpg-agent-info"
#eval $(gpg-agent --daemon)
#eval $(cat ${HOME}/.gpg-agent-info)
ssh-agent -t $SAMAXTIME $WM

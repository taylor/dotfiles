#!/bin/sh

OLDPATH=$PATH
PATH=$HOME/sw/bin:/opt/bin:/bin:/usr/bin:/usr/local/bin:/usr/X11R6/bin:/usr/X11R6/bin/:/opt/pkg/sbin:/opt/pkg/bin

#quartz-wm --only-proxy &

# Load the .Xresources file
xrdb -l $HOME/.Xresources

x=`xmodmap |grep Caps_Lock && echo $?`
if [ $? = 0 ] ; then
  # since hal does not always work....
  #xmodmap -e "clear Lock"
  #xmodmap -e "keycode 66 = Control_L"
  echo "Making the Caps Lock key another Control key"
  xmodmap -e "remove lock = Caps_Lock"
  xmodmap -e "add control = Caps_Lock"
  xmodmap -e "keycode 66 = Control_L"
fi

#~/sw/bin/autocutsel &

# Disable touch pad when typing
# install the xorg-input-synaptics or use the following with SHMConfig on
#syndaemon  -i 1 -S -d &
syndaemon -k -t -i 1 > /dev/null &

# setup gconf so you can use gnome apps w/o trouble
eval `/usr/bin/dbus-launch --sh-syntax --exit-with-session`
/usr/lib/libgconf2-4/gconfd-2 &

#pulse-session &

#eval `gnome-keyring-daemon`

# quake console term - press F5
/usr/bin/tilda &

#quartz-wm
#twm
#evilwm &


#( sleep  5 ; ssh-add ) &

if [ -x "`which ratpoison`" ] ; then
  WM=ratpoison
  # Only useful with ratpoison
  # Moved to .ratpoisonrc for now
  (
    sleep 5
    $HOME/sw/bin/statnot &
    $HOME/sw/bin/purple_rat.py &
    #xmessage "Your battery is funky... not starting ratatat" &
    #ratpoison -c "echo your battery is junk" &
    $HOME/sw/bin/ratatat.py &
  ) &
elif [ -x "`which x-terminal-emulator`" ] ; then
  WM=x-terminal-emulator
else
  WM=xterm
fi

#WM=gnome-session

SAMAXTIME=12000
#ssh-agent -t $SAMAXTIME (ratpoison || x-terminal-emulator || xterm)

PATH=$OLDPATH
ssh-agent -t $SAMAXTIME $WM

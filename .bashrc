# for interactive bash(1) shells only
#[[ $- != *i* ]] && return
if [ -z "$PS1" ]; then
   return
fi

function _vecho() { if [ "${VERBOSE_LOGIN}" = 1 ] ; then echo $* ; fi ; }

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
#export LANG=C

export GPG_KEY_ID=626916EB

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth
# append to the history file, don't overwrite it
shopt -s histappend

########################################################################
## My Prompt
## -- See ~/.bash.d/*command_prompt

# backup for stupidity
if test -z "$BASH_NO_COLOR" && (tput setaf 1) >&/dev/null ; then
  if [ "$TERM" = "xterm" ] ; then
    export TERM=xterm-color
  fi
fi

########################################################################
# functions and aliases are under ~/.bash.d

_vecho -n "Loading ~/.bash.d/*..."
shopt -s nullglob
for s in $HOME/.bash.d/*
do
  [[ -f "$s" ]] && source $s
done
shopt -u nullglob
_vecho "done"


if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi


if [ -n "$DISPLAY" -a -n "$XBROWSER" ] ; then
  export BROWSER=$XBROWSER
fi

case $TERM in
  *screen*|dumb)
    true
    ;;
  *)
    QUIET=1 ~/bin/trans 0.9
    ;;
esac
PATH=/home/taylor/.ghf/bin:$PATH

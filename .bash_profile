# .bash_profile

VERBOSE_LOGIN=1

function _vecho() { if [ "${VERBOSE_LOGIN}" = 1 ] ; then echo $* ; fi ; }

########################################################################

. /etc/profile

EDITOR=vim

HISTCONTROL=ignoreboth
HISTSIZE=10000
HISTFILE=$HOME/.bash_history
HISTFILESIZE=12000

export HISTCONTROL HISTSIZE HISTFILESIZE

# User specific environment and startup programs
unset USERNAME

PATH=/sbin:/usr/sbin:$PATH
PATH=/usr/local/bin:/usr/local/sbin:$PATH
#PATH=$PATH:/usr/bin/vendor_perl
#PATH=$PATH:$HOME/.gem/ruby/1.9.1/bin

CLICOLOR=1

LC_COLLATE=C
export LC_COLLATE

##########################################

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	_vecho "bashrc loading"
	. $HOME/.bashrc
fi


export BROWSER=$HOME/bin/sensible-browser

export GOPATH=$HOME/p/g
PATH=${GOPATH}/bin:$PATH

# I want my bin dir at the front *always*
PATH=$HOME/bin:$PATH

export EDITOR PATH

export MUTTJUMP_INDEXER=notmuch

#export SDL_AUDIODRIVER=pulse
export XDG_CONFIG_HOME=$HOME/.config

#[[ -f /opt/chef/bin/chef-client ]] && export PATH=/opt/chef/bin:$PATH && echo "chef from /opt/chef in use"

ulimit -n 4096
#[ ! -s ~/.config/mpd/pid ] && mpd

export MUSIC_PLAYER=vimpc
#export MUSIC_PLAYER=mocp

#[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

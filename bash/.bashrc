# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh
# https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh
 source ~/.config/git-prompt.sh

# afficher le status de la branche locale (<, >, =)
GIT_PS1_SHOWUPSTREAM=1
# affiche (*) en cas de modifications en zone de travail ou de cache
GIT_PS1_SHOWDIRTYSTATE=1
# affiche (%) en cas de nouveaux fichiers
GIT_PS1_SHOWUNTRACKEDFILES=1
# affiche ($) lorsqu’au moins une zone de stash existe
GIT_PS1_SHOWSTASHSTATE=1
GIT_PS1_HIDE_IF_PWD_IGNORED=1
# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
HISTCONTROL=$HISTCONTROL${HISTCONTROL+:}ignoredups
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoreboth
# append to the history file, don't overwrite it
shopt -s histappend
PROMPT_COMMAND="history -n; history -w; history -c; history -r; $PROMPT_COMMAND"

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
# force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_pro

red='\[\e[0;31m\]'
RED='\[\e[1;31m\]'
blue='\[\e[0;34m\]'
BLUE='\[\e[1;34m\]'
cyan='\[\e[0;36m\]'
CYAN='\[\e[1;36m\]'
green='\[\e[0;32m\]'
GREEN='\[\e[1;32m\]'
yellow='\[\e[0;33m\]'
YELLOW='\[\e[1;33m\]'
PURPLE='\[\e[1;35m\]'
purple='\[\e[0;35m\]'
nc='\[\e[0m\]'

vargitbranch='$(git branch 2>/dev/null)'
varjobs='jobs'

if [ "$UID" = 0 ]; then
    PS1="$red\u$nc@$red\H$nc:$CYAN\w$nc\\n$red#$nc "
else
    #PS1="$PURPLE\u$nc@$CYAN\H$nc:$GREEN\w$nc\\n$GREEN\$$nc "
    PS1='\n\[\e[0;0m\]┌─ \[\e[3;37m\]$(date +"%H:%M:%S") \u\[\e[0;35m\]@\[\e[3;37m\]\H\[\e[0m\]:\[\e[0;37m\](jobs:\j) \[\e[3;32m\]\w/\[\e[0m\] $(__git_ps1 %s)\n\[\e[0;m\]└─>\[\e[0m\]$ '
    
fi
# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --group-directories-first --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Default parameter to send to the "less" command

# -R: show ANSI colors correctly; -i: case insensitive search
LESS="-R -i"

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# Add sbin directories to PATH.  This is useful on systems that have sudo
echo $PATH | grep -Eq "(^|:)/sbin(:|)"     || PATH=$PATH:/sbin
echo $PATH | grep -Eq "(^|:)/usr/sbin(:|)" || PATH=$PATH:/usr/sbin

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
# export MANPAGER="sh -c 'col -bx | batcat -l man -p'"
export PATH="~/bin:$PATH"
export PATH="~/.local/bin:$PATH"

export EDITOR=nvim

# Configuration pour Guix
# export GUIX_LOCPATH="$GUIX_PROFILE/lib/locale"
# export PATH="$GUIX_PROFILE/bin:$GUIX_PROFILE/sbin:$PATH"
# GUIX_PROFILE="$HOME/.config/guix/current"
# GUIX_PROFILE="$HOME/.guix-profile"
# . "$GUIX_PROFILE/etc/profile"

# Automatically added by the Guix install script.
# if [ -n "$GUIX_ENVIRONMENT" ]; then
#    if [[ $PS1 =~ (.*)"\\$" ]]; then
#        PS1="${BASH_REMATCH[1]} [env]\\\$ "
#    fi
#  fi

#Automatically added by the Guix install script.
if [ -n "$GUIX_ENVIRONMENT" ]; then
   if [[ $PS1 =~ (.*)"\\$" ]]; then
       PS1="${BASH_REMATCH[1]} [env]\\\$ "
   fi
 fi

# if [ -n "$GUIX_PROFILE" ]
# then
#     export PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
#     export PS1='\n\[\e[0;0m\]┌─ \[\e[3;37m\]\[Guix\] $(date +"%H:%M:%S") \u\[\e[0;35m\]@\[\e[3;37m\]\H\[\e[0m\]:\[\e[0;37m\](jobs:\j) \[\e[3;32m\]\w/\[\e[0m\] $(__git_ps1 %s)\n\[\e[0;m\]└─>\[\e[0m\]$ '
# else
#     export PS1='\n\[\e[0;0m\]┌─ \[\e[3;37m\]\[\e[0;35m\]GUIX SHELL\[\e[3;37m\] $(date +"%H:%M:%S") \u\[\e[0;35m\]@\[\e[3;37m\]\H\[\e[0m\]:\[\e[0;37m\](jobs:\j) \[\e[3;32m\]\w/\[\e[0m\] $(__git_ps1 %s)\n\[\e[0;m\]└─>\[\e[0m\]$ '
# fi

fortune | lolcat

#!/usr/bin/env bash

unalias -a

alias tcpdump_www='sudo tcpdump -i eth0 -As 10240'

alias cdd=". ~/bin/find-parent-dir"

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

alias lsl="ls -lhFi"
alias lsa="ls -lahFi"

alias ff='find . -iname $*'


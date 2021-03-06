# If not running interactively, don't do anything
[ -z "$PS1" ] && return

#
## Shell options
#

# append to the history file, don't overwrite it
shopt -s histappend

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# argument to the cd builtin command that is not a directory is assumed to be the
# name of a variable whose value is the directory to change to.
shopt -s cdable_vars

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

#
## Set environment variables
#

export EDITOR=vim

# Don't save lines matching the previous history entry
export HISTCONTROL=ignoreboth
# History ignore
export HISTIGNORE="lsl:lsa:cd:cd ..:[bf]g:exit:sd"
# The number of commands to remember in the command history
export HISTSIZE=50000
# The maximum number of lines contained in the history file.
export HISTFILESIZE=$HISTSIZE

# Week starts on monday, show week number, show finnish holidays
export GCAL="-s1 -K --cc-holidays=FI"

#
# Set path
#
function set_path() {
    if [ -z $PATH_MODIFIED ]; then
        export PATH=$PATH:/sbin
        export PATH=$PATH:/usr/sbin
        export PATH=$PATH:/opt/bin
        export PATH=$PATH:~/bin

        if [ -n $JAVA_HOME ]; then
            export PATH=$PATH:$JAVA_HOME/bin
        fi

        export PATH_MODIFIED=1
    fi
}

#
# Load other files
#

function load_file() {
    local file=$1

    if [ -f "$file" ]; then
        source $file
    fi
}

load_file ~/.bash_prompt
load_file ~/.bash_bindings
load_file ~/.bash_cdable
load_file ~/.bash_aliases
load_file ~/.bash_exports
load_file ~/.bash_functions
load_file ~/.bash_completion
load_file ~/.bash_sensitive
load_file /etc/bash_completion # Linux
load_file /usr/local/share/bash-completion/bash_completion.sh # FreeBSD

# Set path after loading everything (mainly exports)
set_path

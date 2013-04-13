#!/usr/bin/env bash

# Load RVM, if you are using it
[[ -s $HOME/.rvm/scripts/rvm ]] && source $HOME/.rvm/scripts/rvm

# Path to the bash it configuration
export BASH_IT=$HOME/.bash_it

# Lock and Load a custom theme file
# location /.bash_it/themes/
export BASH_IT_THEME='bobby'

# Set my editor and git editor
export EDITOR=$(which vim)
export GIT_EDITOR=$(which vim)

# Don't check mail when opening terminal.
unset MAILCHECK

# Change this to your console based IRC client of choice.
export IRC_CLIENT='irssi'

# Set this to the command you use for todo.txt-cli
export TODO="task"

# Set vcprompt executable path for scm advance info in prompt (demula theme)
# https://github.com/xvzf/vcprompt
#export VCPROMPT_EXECUTABLE=~/.vcprompt/bin/vcprompt

# Load Bash It
source $BASH_IT/bash_it.sh

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# Set the locale to American English with UTF-8
export LC_ALL="en_US.UTF-8"

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# Load selection of bash-it plugins
plugins=(base battery dirs fasd git osx python ssh tmux tmuxinator virtualenv)
plugins_enabled="$(bash-it show plugins | egrep \\[x)"
for plugin in ${plugins[@]}
do
    if ( ! $(echo $plugins_enabled | grep -q $plugin) )
    then
        bash-it enable plugin $plugin
    fi
done


# Setup paths
function path_setup()
{
    function path_add()
    {
        function path_add_one()
        {
            if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]
            then
                PATH="${PATH:+"$PATH:"}$1"
            fi
        }

        for p in $@
        do
            path_add_one $p
        done
    }

    function path_generic {
        path_add /sbin /bin /usr/bin /usr/sbin /usr/local/bin /usr/local/sbin

        [[ -x "$(which npm)" ]] && path_add $(npm prefix --global)/bin

        # Add rvm and gems to the path
        [[ -d $HOME/.gem/ruby/1.8/bin ]] && path_add $HOME/.gem/ruby/1.8/bin
    }
    path_generic

    function path_linux {
        [[ "$(uname)" == "Linux" ]] || return
    }
    path_linux

    function path_darwin {
        [[ "$(uname)" == "Darwin" ]] || return

        [[ -d /opt/X11 ]] && path_add /opt/X11/bin

        local server_prefix="/Applications/Server.app/Contents/ServerRoot"
        [[ -d $server_prefix ]] && path_add $server_prefix/bin $server_prefix/sbin

        function path_brew {
            [[ -x "$(which brew)" ]] || return
            local brew_prefix="$(brew --prefix)"
            path_add $brew_prefix/bin $brew_prefix/sbin

            [[ -x $brew_prefix/bin/ruby ]] && path_add $(brew --prefix ruby)/bin
            [[ -d $brew_prefix/share/python ]] && path_add $brew_prefix/share/python
        }
        path_brew
    }
    path_darwin
}
path_setup


# Load dircolor color scheme if available
if [[ -x $(which dircolors) ]]
then
    echo "got it ***"
    if [ -r $HOME/.dircolors ]
    then
        eval "$(dircolors -b $HOME/.dircolors)"
    else
        eval "$(dircolors -b)"
    fi
fi


# Load alias definitions.
[[ -f $HOME/.bash_aliases ]] && . $HOME/.bash_aliases


# Finally load local configuration
[[ -r $HOME/.bash_profile.local ]] && . $HOME/.bash_profile.local


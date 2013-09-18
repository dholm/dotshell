. "${HOME}/.shellrc"


function _setup_bash_it
{
    # Path to the bash it configuration
    export BASH_IT=$HOME/.bash.d/bash_it

    # Lock and Load a custom theme file
    # location /.bash_it/themes/
    export BASH_IT_THEME='bobby'

    # Load Bash It
    source $BASH_IT/bash_it.sh

    # Load selection of bash-it plugins
    local plugins=(base battery dirs fasd git osx python ssh tmux tmuxinator)
    local plugins_enabled="$(bash-it show plugins | egrep \\[x)"
    for plugin in ${plugins[@]}
    do
        if ( ! $(echo $plugins_enabled | grep -q $plugin) )
        then
            bash-it enable plugin $plugin
        fi
    done
}
_setup_bash_it


function _setup_history
{
    # Don't put duplicate lines or lines starting with space in the history.
    HISTCONTROL=ignoreboth

    # append to the history file, don't overwrite it
    shopt -s histappend
}


function _setup_liquidprompt
{
    LIQUIDPROMPT=$HOME/.dotfiles/external/liquidprompt/liquidprompt
    is_readable "${LIQUIDPROMPT}" && . "${LIQUIDPROMPT}"
}
_setup_liquidprompt


function _setup_local_bash
{
    local local_bashrc="$HOME/.bashrc.local"
    local local_bash_aliases="$HOME/.bash_aliases.local"
    is_readable "${local_bashrc}" && . "${local_bashrc}"
    is_readable "${local_bash_aliases}" && . "${local_bash_aliases}"
}
_setup_local_bash


return 0

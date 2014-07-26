if [[ $- != *i* ]]; then
    # Shell is non-interactive, skip everything from this point.
    return
fi


. "${HOME}/.shellrc"


bashrc::bash_it() {
    # Path to the bash it configuration
    export BASH_IT="${HOME}/.bash.d/bash_it"

    # Lock and Load a custom theme file
    # location /.bash_it/themes/
    export BASH_IT_THEME='bobby'

    # Load Bash It
    $(shell::source $BASH_IT/bash_it.sh)

    # Load selection of bash-it plugins
    local plugins; plugins=(
        base battery dirs fasd git osx python ssh tmux tmuxinator
    )
    local plugins_enabled="$(bash-it show plugins | egrep '\[x')"
    for plugin in ${plugins[@]}; do
        if ( ! $(echo $plugins_enabled | grep -q $plugin) ); then
            shell::eval bash-it enable plugin $plugin
        fi
    done
}
shell::eval bashrc::bash_it


bashrc::history() {
    # Don't put duplicate lines or lines starting with space in the history.
    HISTCONTROL=ignoreboth

    # Append to the history file, don't overwrite it.
    shopt -s histappend
}
shell::eval bashrc::history


bashrc::liquidprompt() {
    local liquidprompt="${HOME}/.dotfiles/external/liquidprompt/liquidprompt"
    $(shell::source "${liquidprompt}")
}
shell::eval bashrc::liquidprompt


$(shell::source "${HOME}/.bashrc.local")
$(shell::source "${HOME}/.bash_aliases.local")


if ((PROFILE)); then
    profile::stop
fi

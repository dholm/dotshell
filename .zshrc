if ((PROFILE)); then
    zmodload zsh/zprof
fi

# shellcheck source=../../.shellrc
. "${HOME}/.shellrc"


zshrc::zplug() {
    ###
    # Setup zplug.
    export ZPLUG_HOME="${HOME}/.zsh.d/zplug"
    export ZPLUG_CACHE_DIR="${HOME}/.cache/zplug"
    export ZPLUG_REPOS="${HOME}/.local/share/zplug"
    export ZPLUG_BIN="${HOME}/.local/bin"
    $(shell::source "${ZPLUG_HOME}/init.zsh")

    # Enable self management.
    zplug 'zplug/zplug', hook-build:'zplug --self-manage'
}
shell::is_dumb || shell::eval zshrc::zplug


zshrc::history() {
    # Set path to history file.
    export HISTFILE=~/.zsh_history
    # Increase length of history.
    export HISTSIZE=100000
    export SAVEHIST=${HISTSIZE}

    # Allow multiple terminal sessions to all append to one zsh
    # command history.
    setopt append_history
    # Save time stamp of command and duration.
    setopt extended_history
    # Add commands as they are typed, don't wait until shell exit.
    setopt inc_append_history
    # When trimming history, lose oldest duplicates first.
    setopt hist_expire_dups_first
    # Do not write events to history that are duplicates of previous
    # events.
    setopt hist_ignore_dups
    # Remove command line from history list when first character on
    # the line is a space.
    setopt hist_ignore_space
    # When searching history don't display results already cycled
    # through twice.
    setopt hist_find_no_dups
    # Remove extra blanks from each command line being added to
    # history.
    setopt hist_reduce_blanks
    # Don't execute, just expand history.
    setopt hist_verify
    # Imports new commands and appends typed commands to history.
    setopt share_history

    alias zhistory="builtin history -di 1"

    # Allow patterns in searches by default.
    bindkey '^R' history-incremental-pattern-search-backward
    bindkey '^S' history-incremental-pattern-search-forward
}
shell::eval zshrc::history


zshrc::bookmarks() {
    setopt cd_able_vars
    if [[ -r "${HOME}/.zsh_bookmarks" ]]; then
        # shellcheck source=../../.zsh_bookmarks
        . "${HOME}/.zsh_bookmarks"
    fi
}
shell::is_dumb || shell::eval zshrc::bookmarks


zplug "zsh-users/zsh-completions", if:"! shell::is_dumb"


zshrc::zplug_bundles() {
    zplug "plugins/command-not-found",  from:oh-my-zsh
    zplug "plugins/cp",                 from:oh-my-zsh
    zplug "plugins/battery",            from:oh-my-zsh
    zplug "plugins/extract",            from:oh-my-zsh
    zplug "plugins/dircycle",           from:oh-my-zsh
    zplug "plugins/gnu-utils",          from:oh-my-zsh

    for binary in brew fasd node npm pip python rsync ruby sbt scala ssh-agent svn; do
        path::has_binary "${binary}" && zplug "plugins/${binary}", from:oh-my-zsh
    done

    if path::has_binary go; then
        zplug "plugins/go", from:oh-my-zsh
        zplug "plugins/golang", from:oh-my-zsh
    fi

    if path::has_binary tmux; then
        zplug "plugins/tmux", from:oh-my-zsh
        zplug "plugins/tmuxinator", from:oh-my-zsh
    fi

    if path::has_binary git; then
        zplug "plugins/git", from:oh-my-zsh
        zplug "plugins/git-remote-branch", from:oh-my-zsh
        zplug "plugins/github", from:oh-my-zsh
        zplug "plugins/gitignore", from:oh-my-zsh
    fi

    if path::has_binary hg; then
        zplug "plugins/mercurial", from:oh-my-zsh
    fi

    zplug "plugins/osx", from:oh-my-zsh, if:"os::is_darwin"
}
shell::is_dumb || shell::eval zshrc::zplug_bundles


zshrc::prompt() {
    zplug mafredri/zsh-async, from:github
    zplug sindresorhus/pure, use:pure.zsh, from:github, as:theme

    # Single line prompt.
    export prompt_newline='%666v'
    PROMPT=" $PROMPT"
}
shell::is_dumb || shell::eval zshrc::prompt


zplug "zsh-users/zsh-syntax-highlighting", if:"! shell::is_dumb", defer:2


zshrc::dumb_terminal() {
    # Fallback for dumb terminals (i.e. when running under Emacs Tramp).
    print::debug "Dumb terminal detected, falling back to safe mode."
    unsetopt zle
    unsetopt prompt_cr
    unsetopt prompt_subst
    shell::has_function precmd && unfunction precmd
    shell::has_function preexec && unfunction preexec
}
shell::is_dumb && shell::eval zshrc::dumb_terminal


zshrc::darwin_setup() {
    if [ -d "/usr/share/zsh/help" ]; then
        HELPDIR="/usr/share/zsh/help"
    elif [ -d "/usr/local/share/zsh/help" ]; then
        HELPDIR="/usr/local/share/zsh/help"
    elif path::has_binary brew; then
        unalias run-help
        autoload run-help
        # shellcheck disable=SC2034
        HELPDIR=$(brew --prefix)/share/zsh/help
    fi
}
os::is_darwin && shell::eval zshrc::darwin_setup


# shellcheck source=../../.zshrc.local
# shellcheck disable=SC2091
$(shell::source "${HOME}/.zshrc.local")
# shellcheck source=../../.zsh_aliases.local
# shellcheck disable=SC2091
$(shell::source "${HOME}/.zsh_aliases.local")


###
# Load zplug plugins.
shell::is_dumb || zplug load

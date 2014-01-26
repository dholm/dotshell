. "${HOME}/.shellrc"


zshrc::zsh_completions() {
    local zsh_completions="/usr/local/share/zsh-completions"
    file::is_readable ${zsh_completions} && fpath[1,0]=( ${zsh_completions} )
}
shell::eval zshrc::zsh_completions


zshrc::antigen() {
    ###
    # Setup antigen
    export ADOTDIR="$HOME/.cache/antigen"
    shell::source "$HOME/.zsh.d/bundle/antigen/antigen.zsh"

    # Load bundles from oh-my-zsh
    antigen use oh-my-zsh
}
shell::eval zshrc::antigen


zshrc::antigen_bundles() {
    antigen bundles <<EOB
        command-not-found

        # Copy with progress using cpv
        cp

        # Battery status
        battery

        # Extract any archive
        extract

        # Cycle through directory stack with C-<Shift>-<Left>/<Right>
        dircycle

        # Prefer GNU utils
        gnu-utils
EOB

    file::is_directory "$HOME/.vim/bundle/vundle" && antigen bundle vundle

    for binary in rsync node npm fasd ssh-agent scala sbt ruby svn python pip; do
        path::has_binary "${binary}" && antigen bundle "${binary}"
    done

    path::has_binary task && antigen bundle taskwarrior
    path::has_binary go && antigen bundles <<EOB
        go
        golang
EOB
    path::has_binary tmux && antigen bundles <<EOB
        tmux
        tmuxinator
EOB
    path::has_binary git && antigen bundles <<EOB
        git
        github
EOB
    path::has_binary hg && antigen bundle mercurial
    os::is_darwin && antigen bundle osx
    path::has_binary brew && antigen bundle brew
}
shell::eval zshrc::antigen_bundles


zshrc::liquidprompt() {
    antigen bundle nojhan/liquidprompt
}
shell::eval zshrc::liquidprompt


zshrc::syntax_highlighting() {
    antigen bundle zsh-users/zsh-syntax-highlighting
}
shell::eval zshrc::syntax_highlighting


zshrc::local() {
    local local_zshrc="$HOME/.zshrc.local"
    local local_zsh_aliases="$HOME/.zsh_aliases.local"
    shell::source "${local_zshrc}"
    shell::source "${local_zsh_aliases}"
}
shell::eval zshrc::local


###
# Apply antigen
antigen apply

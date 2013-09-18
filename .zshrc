. "${HOME}/.shellrc"


function _setup_zsh_completions
{
    local zsh_completions="/usr/local/share/zsh-completions"
    is_readable ${zsh_completions} && fpath[1,0]=( ${zsh_completions} )
}
_setup_zsh_completions


function _setup_antigen
{
    ###
    # Setup antigen
    export ADOTDIR="$HOME/.cache/antigen"
    source "$HOME/.zsh.d/bundle/antigen/antigen.zsh"

    # Load bundles from oh-my-zsh
    antigen use oh-my-zsh
}
_setup_antigen


function _setup_antigen_bundles
{
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

    is_directory "$HOME/.vim/bundle/vundle" && antigen bundle vundle

    for binary in rsync node npm fasd ssh-agent scala sbt ruby svn python pip
    do
        has_binary "${binary}" && antigen bundle "${binary}"
    done

    has_binary task && antigen bundle taskwarrior
    has_binary go && antigen bundles <<EOB
        go
        golang
EOB
    has_binary tmux && antigen bundles <<EOB
        tmux
        tmuxinator
EOB
    has_binary git && antigen bundles <<EOB
        git
        github
EOB
    has_binary hg && antigen bundle mercurial
    is_darwin && antigen bundle osx
    has_binary brew && antigen bundle brew
}
_setup_antigen_bundles


function _setup_liquidprompt
{
    antigen bundle nojhan/liquidprompt
}
_setup_liquidprompt


function _setup_syntax_highlighting
{
    antigen bundle zsh-users/zsh-syntax-highlighting
}
_setup_syntax_highlighting


function _setup_local_zsh
{
    local local_zshrc="$HOME/.zshrc.local"
    local local_zsh_aliases="$HOME/.zsh_aliases.local"
    is_readable "${local_zshrc}" && . "${local_zshrc}"
    is_readable "${local_zsh_aliases}" && . "${local_zsh_aliases}"
}
_setup_local_zsh


###
# Apply antigen
antigen apply

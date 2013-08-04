###
# Configure the paths
function
{
    typeset -Ux path
    typeset -Ux fpath

    path[1,0]=(/usr/local/bin /usr/local/sbin)

    function {
        [[ -d $HOME/bin ]] && path[1,0]=( $HOME/bin )
        [[ -x $(which npm 2>/dev/null) ]] && path[1,0]=( $(npm prefix --global)/bin )
        [[ -d $HOME/.cabal/bin ]] && path[1,0]=( $HOME/.cabal/bin )
        [[ -d /opt/cabal ]] && path[1,0]=( /opt/cabal/bin )
    }

    function {
        [[ "$(uname)" == "Linux" ]] || return
    }

    function {
        [[ "$(uname)" == "Darwin" ]] || return

        [[ -d /usr/local/share/zsh-completions ]] && fpath[1,0]=(/usr/local/share/zsh-completions)

        [[ -d /opt/X11 ]] && path[1,0]=( /opt/X11/bin )

        local server_prefix="/Applications/Server.app/Contents/ServerRoot"
        [[ -d $server_prefix ]] && path[1,0]=( $server_prefix/bin $server_prefix/sbin )

        function {
            [[ -x "$(which brew 2>/dev/null)" ]] || return

            local brew_prefix="$(brew --prefix)"
            path[1,0]=($brew_prefix/bin $brew_prefix/sbin)

            [[ -x $brew_prefix/bin/ruby ]] && path[1,0]=( $(brew --prefix ruby)/bin )
            [[ -x $brew_prefix/bin/python3 ]] && path[1,0]=( $(brew --prefix python3)/bin )
            [[ -x $brew_prefix/bin/python ]] && path[1,0]=( $(brew --prefix python)/bin )
            [[ -x $brew_prefix/bin/go ]] && path[1,0]=( $(brew --prefix go)/bin )
        }
    }
}


###
# Setup antigen
ADOTDIR=$HOME/.cache/antigen
source $HOME/.dotfiles/zsh/bundle/antigen/antigen.zsh

# Load bundles from oh-my-zsh
antigen use oh-my-zsh

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

[[ -d $HOME/.vim/bundle/vundle ]] && antigen bundle vundle

(( $+commands[rsync] )) && antigen bundle rsync
(( $+commands[task] )) && antigen bundle taskwarrior
(( $+commands[node] )) && antigen bundle node
(( $+commands[npm] )) && antigen bundle npm
(( $+commands[fasd] )) && antigen bundle fasd
(( $+commands[ssh-agent] )) && antigen bundle ssh-agent


###
# Version control systems
(( $+commands[git] )) && antigen bundles <<EOB
    git
    github
EOB
(( $+commands[hg] )) && antigen bundle mercurial
(( $+commands[svn] )) && antigen bundle svn


###
# TMUX
(( $+commands[tmux] )) && antigen bundles <<EOB
    tmux
    tmuxinator
EOB


###
# Go
(( $+commands[go] )) && antigen bundles <<EOB
    go
    golang
EOB


###
# Ruby
(( $+commands[ruby] )) && antigen bundle ruby


###
# OSX settings
[[ "$(uname)" == "Darwin" ]] && antigen bundle osx
(( $+commands[brew] )) && antigen bundle brew


###
# Scala
(( $+commands[scala] )) && antigen bundle scala
(( $+commands[sbt] )) && antigen bundle sbt


###
# Default to UTF-8
export LANG="en_US.UTF_8"
export LC_ALL="en_US.UTF-8"
# Keep the default sort order (e.g. files starting with a '.'
# should appear at the start of a directory listing.)
export LC_COLLATE="C"
# Set the short date to YYYY-MM-DD (test with "date +%c")
export LC_TIME="sv_SE.UTF-8"


###
# Terminal setup
if [ "$TERM" = "xterm" ]
then
    export TERM="xterm-256color"
fi


###
# Load dircolor color scheme if available
if [[ -x $(which dircolors 2>/dev/null) ]]
then
    if [ -r "$HOME/.dircolors" ]
    then
        eval "$(dircolors -b $HOME/.dircolors)"
    else
        eval "$(dircolors -b)"
    fi
fi


###
# Python configuration
if (( $+commands[python] ))
then
    export VIRTUALENV_DISTRIBUTE=true
    antigen bundle python

    if (( $+commands[pip] ))
    then
        antigen bundle pip

        export PIP_REQUIRE_VIRTUALENV=true
        export PIP_DOWNLOAD_CACHE="$HOME/.cache/pip"
        function syspip()
        {
            PIP_REQUIRE_VIRTUALENV="" pip "$@"
        }
    fi
fi


###
# Set editor, git editor and pager
export EDITOR=$(which vim)
export GIT_EDITOR=$(which vim)
export PAGER=$(which vimpager)


###
# Setup liquidprompt
antigen bundle nojhan/liquidprompt


###
# Steal alias definitions from Bash
[[ -s $HOME/.bash_aliases ]] && . $HOME/.bash_aliases


###
# Syntax highlighting
antigen bundle zsh-users/zsh-syntax-highlighting


###
# Setup fontconfig-ultimate
. $HOME/.dotfiles/external/fontconfig-ultimate/freetype/infinality-settings.sh


###
# Source any local settings
[[ -s $HOME/.zshrc.local ]] && . $HOME/.zshrc.local
[[ -s $HOME/.bash_aliases.local ]] && . $HOME/.bash_aliases.local


###
# Apply antigen
antigen apply

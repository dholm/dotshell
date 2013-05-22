###
# Setup oh-my-zsh
ZSH=$HOME/.oh-my-zsh
ZSH_THEME="agnoster"
COMPLETION_WAITING_DOTS="true"
plugins=(battery brew cp dircycle extract fasd git-extras git-flow git
         gitfast github osx pip python rsync ssh-agent taskwarrior npm
         vundle tmux tmuxinator)

source $ZSH/oh-my-zsh.sh


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
            [[ -d $brew_prefix/share/python ]] && path[1,0]=( $brew_prefix/share/python )
        }
    }
}


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
# Set editor, git editor and pager
export EDITOR=$(which vim)
export GIT_EDITOR=$(which vim)
export PAGER=$(which vimpager)


###
# Set the locale to American English with UTF-8
export LC_ALL="en_US.UTF-8"


###
# Steal alias definitions from Bash
[[ -s $HOME/.bash_aliases ]] && . $HOME/.bash_aliases


###
# Source any local settings
[[ -s $HOME/.zshrc.local ]] && . $HOME/.zshrc.local

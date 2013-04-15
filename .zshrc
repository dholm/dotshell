# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="agnoster"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how many often would you like to wait before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(battery brew cp dircycle extract fasd git-extras git-flow git
         gitfast github osx pip python rsync ssh-agent taskwarrior npm
         vundle tmux tmuxinator)

source $ZSH/oh-my-zsh.sh


# Set up the paths
function
{
    typeset -U path
    path+=(/sbin /bin /usr/bin /usr/sbin /usr/local/bin /usr/local/sbin)

    function {
        [[ -d $HOME/bin ]] && path+=( $HOME/bin )
        [[ -x $(which npm) ]] && path+=( $(npm prefix --global)/bin )
        [[ -d $HOME/.cabal/bin ]] && path+=( $HOME/.cabal/bin )
    }

    function {
        [[ "$(uname)" == "Linux" ]] || return
    }

    function {
        [[ "$(uname)" == "Darwin" ]] || return

        [[ -d /opt/X11 ]] && path+=( /opt/X11/bin )

        local server_prefix="/Applications/Server.app/Contents/ServerRoot"
        [[ -d $server_prefix ]] && path+=( $server_prefix/bin $server_prefix/sbin )

        function {
            [[ -x "$(which brew)" ]] || return
            local brew_prefix="$(brew --prefix)"
            path+=($brew_prefix/bin $brew_prefix/sbin)

            [[ -x $brew_prefix/bin/ruby ]] && path+=( $(brew --prefix ruby)/bin )
            [[ -d $brew_prefix/share/python ]] && path+=( $brew_prefix/share/python )
        }
    }
}


# Set editor and git editor
export EDITOR=$(which vim)
export GIT_EDITOR=$(which vim)

# Set the locale to American English with UTF-8
export LC_ALL="en_US.UTF-8"

# Steal alias definitions from Bash
[[ -s $HOME/.bash_aliases ]] && . $HOME/.bash_aliases

# Source any local settings
[[ -s $HOME/.zshrc.local ]] && . $HOME/.zshrc.local

# Set up the alias for managing dotfiles
alias dotfiles='git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME'

# Use colors for coreutils
if ( ls --color 1>/dev/null 2>&1 )
then
    alias ls='ls --color=auto'
elif ( ls -G 1>/dev/null 2>&1 )
then
    alias ls='ls -G'
fi
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

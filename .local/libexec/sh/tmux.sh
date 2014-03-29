tmux::setup() {
    path::has_binary tmuxifier && shell::eval "$(tmuxifier init -)"
}
shell::eval tmux::setup

dircolors::setup() {
    local dircolors_path="${HOME}/.dircolors"

    if file::is_readable "${dircolors_path}"; then
        eval "$(dircolors -b ${dircolors_path})"
    else
        eval "$(dircolors -b)"
    fi
}
shell::eval dircolors::setup

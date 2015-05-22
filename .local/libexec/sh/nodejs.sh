nodejs::setup() {
    if path::has_binary npm; then
        path::prepend "${HOME}/.local/lib/nodejs/bin"
    fi
}
shell::eval nodejs::setup

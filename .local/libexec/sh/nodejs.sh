nodejs::setup() {
    if path::has_binary npm; then
        path::prepend "$(npm bin --global)"
    fi
}
shell::eval nodejs::setup

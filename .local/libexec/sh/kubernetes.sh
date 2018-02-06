kubernetes::setup() {
    source <(kubectl completion $(shell::name))
    if path::has_binary helm; then
        source <(helm completion $(shell::name))
    fi
    return 0
}
path::has_binary kubectl && shell::eval kubernetes::setup

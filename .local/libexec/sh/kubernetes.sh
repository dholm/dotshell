kubernetes::setup() {
    source <(kubectl completion $(shell::name))
    return 0
}
path::has_binary kubectl && shell::eval kubernetes::setup

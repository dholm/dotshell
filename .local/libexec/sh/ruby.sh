ruby::setup() {
    local rvm_script="${HOME}/.rvm/scripts/rvm"

    if file::is_readable "${rvm_script}"; then
        $(shell::source "${rvm_script}")
    fi
}
shell::eval ruby::setup

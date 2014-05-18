ruby::_setup_darwin() {
    if path::has_binary rbenv; then
        export RBENV_ROOT="$(homebrew::prefix)/var/rbenv"
    fi
}

ruby::setup() {
    os::is_darwin && ruby::_setup_darwin

    local rvm_script="${HOME}/.rvm/scripts/rvm"
    if file::is_readable "${rvm_script}"; then
        $(shell::source "${rvm_script}")
    fi

    if path::has_binary rbenv; then
        shell::eval "$(rbenv init -)"
    fi
}
shell::eval ruby::setup

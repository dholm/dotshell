service::darwin::has() {
    local service="${1}"

    local has_exp="^([-[:digit:]]+[[:space:]]+){2}${service}$"
    if shell::exec launchctl list | egrep -q ${has_exp}; then
        print::debug "Service ${service} exists."
        return 0
    fi

    return 1
}

service::linux::has() {
    local service="${1}"

    if path::has_binary service; then
        shell::exec sudo service ${service} status >/dev/null
        if ((${?} == 1)); then
            print::debug "Service ${service} exists."
            return 0
        fi
    fi

    return 1
}

service::darwin::is_running() {
    local service="${1}"

    local running_exp="^[AD][[:space:]]+${service}$"
    if shell::exec launchctl bslist | egrep -q ${running_exp}; then
        print::debug "Service ${service} is running."
        return 0
    fi

    return 1
}

service::linux::is_running() {
    local service="${1}"

    if path::has_binary service; then
        shell::exec sudo service ${service} status >/dev/null
        if ((${?} == 0)); then
            print::debug "Service ${service} is running."
            return 0
        fi
    fi

    return 1
}

service::darwin::restart() {
    local service="${1}"

    shell::exec sudo launchctl stop ${service}
    if ((${?} != 0)); then
        print::warning "Failed to stop ${service}, attempting to start anyway."
    fi
    shell::exec sudo launchctl start ${service}
    if ((${?} != 0)); then
        print::warning "Failed to start ${service}!"
        return 1
    fi

    print::debug "Service ${service} has been restarted."
    return 0
}

service::linux::restart() {
    local service="${1}"

    if path::has_binary service; then
        shell::exec sudo service ${service} restart >/dev/null
        if ((${?} != 0)); then
            print::error "Failed to restart service ${service}!"
            return 1
        fi
        print::debug "Service ${service} has been restarted."
        return 0
    fi

    return 1
}

service::has() {
    local service="${1}"

    if os::is_darwin; then
        return $(service::darwin::has ${service})
    elif os::is_linux; then
        return $(service::linux::has ${service})
    fi

    return 1
}

service::is_running() {
    local service="${1}"

    if os::is_darwin; then
        return $(service::darwin::is_running ${service})
    elif os::is_linux; then
        return $(service::linux::is_running ${service})
    fi

    return 1
}

service::restart() {
    local service="${1}"

    if os::is_darwin; then
        return $(service::darwin::restart ${service})
    elif os::is_linux; then
        return $(service::linux::restart ${service})
    fi

    return 1
}

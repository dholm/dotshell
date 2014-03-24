_ssh_config_files=( "$HOME/.ssh/conf" "$HOME/.ssh/conf.local" )

ssh::authorize_host() {
    local host="${1}"
    local key="${2:-${HOME}/.ssh/id_rsa.pub}"

    if ! file::is_readable "${key}"; then
        print::error "Unable to read key ${key}!"
        return 1
    fi

    local retval=1
    if path::has_binary ssh-copy-id; then
        shell::exec ssh-copy-id -i ${key} ${host}
        retval="${?}"
    else
        local ssh_remote_cmd="mkdir -p ~/.ssh; cat >> ~/.ssh/authorized_keys"
        shell::eval cat ${key} | ssh ${host} ${ssh_remote_cmd}
        retval="${?}"
    fi

    if [ "${retval}" -ne 0 ]; then
        print::error "Failed to authorize host ${host} for key ${key}!"
    fi

    return ${retval}
}

ssh::wrapper() {
    local args="${*}"
    local config_fifo="$(mktemp -u --suffix=_ssh_config)"

    print::debug "Setting up configuration FIFO ${config_fifo}.."
    mkfifo "${config_fifo}"
    chmod 600 "${config_fifo}"
    set +m
    cat ${_ssh_config_files[@]} >"${config_fifo}" 2>/dev/null &

    local ssh_args="-F ${config_fifo} ${args}"
    shell::exec ssh ${ssh_args}

    rm -f "${config_fifo}"
}

ssh::nohostkey() {
    local args="${*}"
    local host="${@: -1}"

    shell::exec $(path::to ssh-keygen) -f "${HOME}/.ssh/known_hosts" -R ${host}
    shell::exec $(path::to ssh) ${args}
}

ssh::setup() {
    # Currently broken on Ubuntu and OSX
    #alias::add ssh "ssh -F <(cat ${_ssh_config_files[*]} 2>/dev/null)"
    #if os::is_linux; then
    #    alias::add ssh ssh::wrapper
    #fi
}

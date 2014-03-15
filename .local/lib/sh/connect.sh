typeset -A _connect_host_table

connect::add() {
    local name="${1}"
    local url="${2}"

    if url::is_valid ${url}; then
        print::debug "Adding ${name} (${url}) to host table"
        _connect_host_table[${name}]=${url}
        return 0
    else
        print::error "Url ${url} failed validation!"
    fi
    return 1
}

connect::ssh::to() {
    local url="${1}"; shift
    local args="${*}"

    local ssh_args=""
    local user="$(url::get_user ${url})"
    if [[ -n "${user}" ]]; then
        ssh_args="${ssh_args} -l ${user}"
    fi

    local port="$(url::get_port ${url})"
    if [[ -n "${port}" ]]; then
        ssh_args="${ssh_args} -p ${port}"
    fi

    local host="$(url::get_host ${url})"
    if [[ -z "${host}" ]]; then
        print::error "URL does not contain hostname: ${url}!"
        return 1
    fi

    ssh_args="${ssh_args} ${args}"
    shell::exec $(path::to ssh) ${ssh_args} ${host}
}

connect::ssl::to() {
    local url="${1}"; shift
    local args="${*}"

    local host="$(url::get_host ${url})"
    if [[ -z "${host}" ]]; then
        print::error "URL does not contain hostname: ${url}!"
        return 1
    fi

    local port="$(url::get_port ${url})"
    if [[ -z "${host}" ]]; then
        print::error "URL does not contain port: ${url}!"
        return 1
    fi

    local openssl_args="s_client -connect ${host}:${port} -crlf -quiet"
    shell::exec $(path::to openssl) ${openssl_args}
}

connect::telnet::to() {
    local url="${1}"; shift
    local args="${*}"

    local telnet_args=""
    local user="$(url::get_user ${url})"
    if [[ -n "${user}" ]]; then
        telnet_args="${telnet_args} -l ${user}"
    fi

    local host="$(url::get_host ${url})"
    if [[ -z "${host}" ]]; then
        print::error "URL does not contain hostname: ${url}!"
        return 1
    fi
    telnet_args="${telnet_args} ${host}"

    local port="$(url::get_port ${url})"
    if [[ -n "${host}" ]]; then
        telnet_args="${telnet_args} ${port}"
    fi

    shell::exec $(path::to telnet) ${telnet_args}
}

connect::to() {
    local system="${1}"; shift
    local args="${*}"

    local url="${_connect_host_table[${system}]}"
    if [[ -n "${url}" ]]; then
        print::info "Connecting to ${url}.."
        local scheme="$(url::get_scheme ${url})"
        case "${scheme}" in
            ssh) connect::ssh::to ${url} ${args};;
            ssl) connect::ssl::to ${url} ${args};;
            telnet) connect::telnet::to ${url} ${args};;
            *) print::error "Unsupported scheme: ${scheme}!";;
        esac
    fi
}

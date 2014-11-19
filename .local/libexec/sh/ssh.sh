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
    local usage="Usage:
 -p --password  - Force password login.
 -X --x11       - Forward X11 protocol.
 -h --help      - Print help.
"
    eval $(shell::args_parse "pXh" "password,x11,help")

    local opts; typeset -A opts
    opts[password]=false
    opts[x11]=false
    while true; do
        case "${1}" in
            -p|--password) opts[password]=true;;
            -X|--x11) opts[x11]=true;;
            -h|--help) print::info ${usage}; return 0;;
            --) shift; break;;
            *) print::error "Unknown option: ${1}"; return 1;;
        esac
        shift
    done
    local args="${*}"

    local config_pipe=""
    local ssh_args=""
    if false; then
        # Currently broken on Ubuntu and Darwin.
        print::debug "Setting up configuration FIFO ${config_fifo}.."
        local config_fifo="$(mktemp -u --suffix=_ssh_config)"
        mkfifo "${config_fifo}"
        chmod 600 "${config_fifo}"
        set +m
        cat ${_ssh_config_files[@]} >"${config_fifo}" 2>/dev/null &
        ssh_args="${ssh_args} -F ${config_fifo}"
        config_pipe="-F <(cat ${_ssh_config_files[*]} 2>/dev/null)"
    fi

    if ${opts[password]}; then
        ssh_args="${ssh_args} -o PubkeyAuthentication=no"
    fi
    if ${opts[x11]}; then
        ssh_args="${ssh_args} -X -Y"
    fi

    ssh_args="${ssh_args} ${args}"
    shell::exec ssh ${ssh_args} ${config_pipe}

    rm -f "${config_fifo}"
}

ssh::nohostkey() {
    local args="${*}"
    local host="${@: -1}"

    shell::exec $(path::to ssh-keygen) -f "${HOME}/.ssh/known_hosts" -R ${host}
    shell::exec $(path::to ssh) ${args}
}

ssh::setup() {
    :
}
shell::eval ssh::setup

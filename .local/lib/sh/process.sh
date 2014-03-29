process::hangup() {
    local usage="Usage:
 -p --privileged  - Send hangup as privileged user.
 -h --help        - Print help.
"
    eval $(shell::args_parse "hp" "help,privileged" "${@}")

    local opts; typeset -A opts
    opts[privileged]=false
    while true; do
        case "${1}" in
            -p|--privileged) opts[privileged]=true;;
            -h|--help) print::info ${usage}; return 0;;
            --) shift; break;;
            *) print::error "Unknown option: ${1}"; return 1;;
        esac
        shift
    done
    local process="${1}"

    local cmd="killall"
    if ${opts[privileged]}; then
        cmd="sudo ${cmd}"
    fi

    shell::exec ${cmd} -HUP "${process}" &>/dev/null
    if ((${?} != 0)); then
        print::debug "Failed to hang up ${process}!"
        return 1
    fi

    return 0
}

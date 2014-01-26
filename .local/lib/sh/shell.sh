shell::is_zsh() {
    test -n "$ZSH_VERSION"
}

shell::is_bash() {
    test -n "$BASH_VERSION"
}

export callee
export caller
export this
if shell::is_zsh; then
    callee='echo ${funcstack[0]}'
    caller='echo ${funcstack[1]}'
    this='echo ${0}'
elif shell::is_bash; then
    callee='echo ${FUNCNAME[0]}'
    caller='echo ${FUNCNAME[1]}'
    this='echo ${BASH_SOURCE}'
fi

shell::as_array() {
    local name="${1}"
    if shell::is_zsh; then
        echo "${name}"
    elif shell::is_bash; then
        echo "${name}[@]"
    fi
}

shell::eval() {
    local fn="${1}"; shift 1
    local args="${*}"

    print::debug "${fn}(${args}): Begin"
    eval ${fn} ${args}
    local retval="$?"
    print::debug "${fn}(${args}): End (${retval})"
    return ${retval}
}

shell::source() {
    local file="${1}"

    if file::is_readable "${file}"; then
        print::debug "${file}: Begin"
        source "${file}"
        print::debug "${file}: End"
    fi
}

shell::exec_env() {
    local env
    if shell::is_bash; then
        env=( "${!1}" )
    elif shell::is_zsh; then
        env=( "${(P)${1}[@]}" )
    fi; shift
    local cmd="${1}"; shift
    local flags="${*}"

    print::debug "(env={${env[@]}} cmd=${cmd} flags={${flags}}): Begin"
    /usr/bin/env "${env[@]}" ${cmd} ${flags}
    local retval="$?"
    print::debug "(env={${env[@]}} cmd=${cmd} flags={${flags}}): End (${retval})"
    return ${retval}
}

shell::exec() {
    local cmd="${1}"; shift
    local args="${*}"

    local nil_env; nil_env=( )
    shell::exec_env $(shell::as_array nil_env) ${cmd} ${args}
}

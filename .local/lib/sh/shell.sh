. "$HOME/.local/lib/sh/print.sh"

shell::is_zsh() {
    test -n "${ZSH_VERSION}"
}

shell::is_bash() {
    test -n "${BASH_VERSION}"
}

export callee
export caller
export this
if shell::is_zsh; then
    callee='echo ${funcstack[2]}'
    caller='echo ${funcstack[3]}'
    this='echo ${0:-${_}}'
elif shell::is_bash; then
    callee='echo ${FUNCNAME[0]}'
    caller='echo ${FUNCNAME[1]}'
    this='echo ${BASH_SOURCE[0]:-${_}}'
fi

shell::is_non_interactive() {
    [[ $- != *i* ]]
}

shell::has_function() {
    local name="${1}"
    if shell::is_zsh; then
        local t="$(type ${name})"
        echo ${t} | grep -q function
    elif shell::is_bash; then
        local t="$(shell::eval type -t ${name})"
        [[ "${t}" == "function" ]]
    fi
}

shell::as_array() {
    local name="${1}"
    if shell::is_zsh; then
        echo "${name}"
    elif shell::is_bash; then
        echo "${name}[@]"
    fi
}

shell::from_array() {
    local param="${1}"

    if shell::is_bash; then
        echo "echo \${!${param}}"
    elif shell::is_zsh; then
        echo "echo \${(P)\${${param}}[@]}"
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
    local file="${1}"; shift
    local args="${*}"

    echo eval " \
    if file::is_readable ${file}; then \
        print::debug \"file=${file} args={${args}}: Begin\"; \
        source ${file} ${args}; \
        print::debug \"file=${file} args]{${args}}: End\"; \
    fi \
    "
}

shell::pushd() { pushd "${1}" >/dev/null }
shell::popd() { popd >/dev/null }

shell::exec_env() {
    local env; env=( $(eval $(shell::from_array 1)) ); shift
    local cmd="${1}"; shift
    local args="${*}"

    print::debug "(env={${env[@]}} cmd=${cmd} args={${args}}): Begin"
    eval /usr/bin/env "${env[@]}" ${cmd} ${args}
    local retval="${?}"
    print::debug "(env={${env[@]}} cmd=${cmd} args={${args}}): End (${retval})"
    return ${retval}
}

shell::exec() {
    local cmd="${1}"; shift
    local args="${*}"

    local nil_env; nil_env=( )
    shell::exec_env $(shell::as_array nil_env) ${cmd} ${args}
    return ${?}
}

shell::args_parse() {
    local short="${1}"; shift
    local long="${1}"; shift

    print::debug "short=${short} long=${long}"
    local cmd="getopt"
    if os::is_darwin; then
        cmd="$(brew --prefix gnu-getopt)/bin/getopt"
    fi

    local get_opts="${cmd} -o ${short} --long ${long} -n $(eval ${caller})"
    echo "eval set -- \$(${get_opts} -- \"\${@}\")"
}

path::remove() {
    local dir="${1}"

    print::debug "Removing '${dir}' from path"

    if shell::is_zsh; then
        local idx=${path[(i)${dir}]}
        path[idx]=()
    elif shell::is_bash; then
        PATH=`echo -n $PATH | awk -v RS=: -v ORS=: '$0 != "'${dir}'"' | sed 's/:$//'`
    fi
}

path::prepend() {
    local dir="${1}"

    print::debug "Prepending '${dir}' to path"

    if path::exists "${dir}"; then
        path::remove "${dir}"
    fi

    if shell::is_zsh; then
        path[1,0]="${dir}"
    elif shell::is_bash; then
        if [[ ":$PATH:" != *":${dir}:"* ]]; then
            PATH="${dir}:${PATH+"$PATH"}"
        fi
    fi
}

path::append() {
    local dir="${1}"

    print::debug "Appending '${dir}' to path"

    path::remove "${dir}"
    if shell::is_zsh; then
        path+="${dir}"
    elif shell::is_bash; then
        if [[ ":$PATH:" != *":${dir}:"* ]]; then
            PATH="${PATH+"$PATH"}:${dir}"
        fi
    fi
}

path::has_binary() {
    local binary="${1}"

    if shell::is_zsh; then
        return $((1 - $+commands[${binary}]))
    elif shell::is_bash; then
        hash "${binary}" &>/dev/null
    fi
}

path::to() {
    local binary="${1}"

    if shell::is_zsh; then
        echo $commands[${binary}]
    elif shell::is_bash; then
        which "${binary}"
    fi
}

path::exists() {
    local dir="${1}"
    [[ ":$PATH:" == *":${dir}:"* ]]
}

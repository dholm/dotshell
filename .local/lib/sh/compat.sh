compat::version() {
    echo "$@" | awk -F. '{ printf("%d.%d.%d\n", $1,$2,$3); }'
}

compat::version_norm() {
    local base="${1}"
    local version="${2}"

    local components=$(( $(string::words "$(string::split . ${base})") ))
    local vsplit; vsplit=( $(string::split . "${version}") )
    local vnorm; vnorm=( ${vsplit[@]:0:${components}} )

    echo "$(string::join . $(shell::as_array vnorm))"
}

compat::shell::has_associative_arrays() {
    if shell::is_zsh; then
        return 0
    elif shell::is_bash; then
        if [[ "$(compat::version ${BASH_VERSION})" < "$(compat::version 4.0.0)" ]]; then
            return 1
        fi
        return 0
    fi

    return 1
}

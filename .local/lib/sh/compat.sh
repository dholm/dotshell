compat::version() {
    echo "$@" | gawk -F. '{ printf("%d.%d.%d\n", $1,$2,$3); }'
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

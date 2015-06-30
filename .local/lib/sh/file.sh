file::abs() {
    local file="${1}"
    if os::is_darwin; then
        shell::exec readlink "${file}"
    else
        shell::exec readlink -e "${file}"
    fi
}

file::is_directory() {
    local directory="${1}"
    test -d "${directory}"
}

file::is_executable() {
    local file="${1}"
    test -x "${file}"
}

file::is_readable() {
    local file="${1}"
    test -r "${file}"
}

file::exists() {
    local paths_glob="${*}"
    local retval=1

    if [ -n "${paths_glob}" ]; then
        shell::is_zsh && unsetopt nomatch
        shell::exec ls -1 ${paths_glob} 2>/dev/null
        retval=${?}
        shell::is_zsh && setopt nomatch
    fi

    return ${retval}
}

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

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

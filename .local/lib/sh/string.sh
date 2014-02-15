string::split() {
    local delimiter="${1}"
    local str="${2}"

    if shell::is_zsh; then
        setopt shwordsplit
    fi

    local old_ifs="${IFS}"
    IFS="${delimiter}"
    local array; array=( ${str} )
    IFS="${old_ifs}"

    echo ${array[@]}
}

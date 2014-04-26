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

string::word() {
    local nth=$(( ${1} ))
    local str="${2}"

    echo "${str}" | cut -d \  -f ${nth}
}

string::words() {
    local str="${1}"

    echo $(( $(wc -w <<< "${str}") ))
}

string::join() {
    local delimiter="${1}"
    local array; array=( $(eval $(shell::from_array 2)) )

    if shell::is_zsh; then
        setopt shwordsplit
    fi

    local old_ifs="${IFS}"
    IFS="${delimiter}"
    local joined="${array[*]}"
    IFS="${old_ifs}"

    echo "${joined}"
}

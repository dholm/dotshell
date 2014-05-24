array::find() {
    local haystack; haystack=( $(eval $(shell::from_array 1)) ); shift
    local needle="${1}"

    for ((i = 0; i < ${#haystack[@]}; ++i)); do
        if [ "${needle}" = "${haystack[${i}]}" ]; then
            break
        fi
    done

    if [[ "${i}" == ${#haystack[@]} ]]; then
        return 1
    fi

    echo "${i}"
    return 0
}

_alist_compat_delimiter="\036"

alist::typeset() {
    local alist="${1}"

    if compat::shell::has_associative_arrays; then
        echo "typeset -A ${alist}"
    else
        echo "typeset -a ${alist}"
    fi
}

alist::add() {
    local alist="${1}"
    local key="${2}"
    local value="${3}"

    if compat::shell::has_associative_arrays; then
        echo "${alist}[${key}]=\"${value}\""
    else
        echo "${alist}=( \"\${${alist}[@]}\" \"${key}${_alist_compat_delimiter}${value}\" )"
    fi
}

alist::get() {
    local alist="${1}"
    local key="${2}"

    if compat::shell::has_associative_arrays; then
        echo "echo \"\${${alist}[${key}]}\""
    else
        echo " \
        for kvp in \"\${${alist}[@]}\"; do \
            current_key=\"\${kvp%%${_alist_compat_delimiter}*}\"; \
            current_value=\"\${kvp#*${_alist_compat_delimiter}}\"; \
            if [[ \"\${current_key}\" = \"${key}\" ]]; then \
                echo \${current_value}; \
                break; \
            fi; \
        done \
        "
    fi
}

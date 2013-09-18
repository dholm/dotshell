function path_prepend
{
    local dir="${1}"

    if is_zsh
    then
        path[1,0]="${dir}"
    elif is_bash
    then
        PATH="${dir}:$PATH"
    fi
}

function path_append
{
    local dir="${1}"

    if is_zsh
        path+="${dir}"
    then
    elif is_bash
    then
        PATH+=:"${dir}"
    fi
}

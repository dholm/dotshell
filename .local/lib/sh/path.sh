function path_remove
{
    local dir="${1}"

    if is_zsh
    then
        local idx=${path[(i)${dir}]}
        path[idx]=()
    elif is_bash
    then
        PATH=`echo -n $PATH | awk -v RS=: -v ORS=: '$0 != "'${dir}'"' | sed 's/:$//'`
    fi
}

function path_prepend
{
    local dir="${1}"

    path_remove "${dir}"
    if is_zsh
    then
        path[1,0]="${dir}"
    elif is_bash
    then
        if [[ ":$PATH:" != *":${dir}:"* ]]
        then
            PATH="${dir}:${PATH+"$PATH"}"
        fi
    fi
}

function path_append
{
    local dir="${1}"

    path_remove "${dir}"
    if is_zsh
    then
        path+="${dir}"
    elif is_bash
    then
        if [[ ":$PATH:" != *":${dir}:"* ]]
        then
            PATH="${PATH+"$PATH"}:${dir}"
        fi
    fi
}

function is_directory
{
    local directory="${1}"
    test -d "${directory}"
}

function is_executable
{
    local file="${1}"
    test -x "${file}"
}

function is_readable
{
    local file="${1}"
    test -r "${file}"
}

function has_binary
{
    local binary="${1}"

    if is_zsh
    then
        return $((1 - $+commands[${binary}]))
    elif is_bash
    then
        hash "${binary}" &>/dev/null
    fi
}

function path_to
{
    local binary="${1}"

    if is_zsh
    then
        echo $commands[${binary}]
    elif is_bash
    then
        which "${binary}"
    fi
}

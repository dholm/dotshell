function alias_add
{
    local cmd="${1}"
    local _alias="${2}"

    debug "Aliasing ${cmd} to '${_alias}'"
    alias ${cmd}="${_alias}"
}

function alias_remove
{
    local cmd="${1}"

    debug "Removing alias ${cmd}"
    unalias ${cmd}
}

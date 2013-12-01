function alias_add
{
    local cmd="${1}"
    local _alias="${2}"

    alias ${cmd}="${_alias}"
}

function alias_remove
{
    local cmd="${1}"

    unalias ${cmd}
}

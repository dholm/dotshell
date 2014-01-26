alias::add() {
    local cmd="${1}"
    local _alias="${2}"

    print::debug "Aliasing ${cmd} to '${_alias}'"
    alias ${cmd}="${_alias}"
}

alias::remove() {
    local cmd="${1}"

    print::debug "Removing alias ${cmd}"
    unalias ${cmd}
}

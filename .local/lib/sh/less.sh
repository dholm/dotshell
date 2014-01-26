less::src() {
    local args="${*}"

    local lessenv
    lessenv=( LESS="-MiR" )
    if path::has_binary pygmentize; then
        lessenv+=( LESSOPEN="| pygmentize -g %s" )
    fi

    shell::exec_env $(shell::as_array lessenv) $(path::to less) ${args}
}

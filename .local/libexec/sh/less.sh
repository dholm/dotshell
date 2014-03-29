export PYGMENTIZE_STYLE="native"

less::src() {
    local args="${*}"

    local lessenv
    lessenv=( LESS="-MiR" )
    if path::has_binary pygmentize; then
        local pygmentize_opts="style=${PYGMENTIZE_STYLE}"
        local pygmentize_args="-f terminal256 -O ${pygmentize_opts}"
        lessenv+=( LESSOPEN="\"| pygmentize ${pygmentize_args} -g %s\"" )
    fi

    shell::exec_env $(shell::as_array lessenv) $(path::to less) ${args}
}

less::setup() {
    # Display ANSI color codes by default.
    LESS="-R"
    # Use verbose pager.
    LESS="${LESS}M"

    # Commit options.
    export LESS

    # Use less as default pager.
    export PAGER=$(path::to less)
}
shell::eval less::setup

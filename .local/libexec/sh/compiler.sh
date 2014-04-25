compiler::dump_defines() {
    local compiler_bin="${1}"; shift
    local compiler_args="${*}"

    print::debug "(${compiler_bin} ${compiler_args}): Begin"
    local args="${compiler_args} -dM -E -x -"
    shell::exec ${compiler_bin} ${args} </dev/null
    local retval="$?"
    print::debug "(${compiler_bin} ${compiler_args}): End (${retval})"

    return ${retval}
}

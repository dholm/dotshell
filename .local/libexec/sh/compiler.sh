compiler::_dump() {
    local compiler_bin="${1}"; shift
    local compiler_args="${*}"

    print::debug "(${compiler_bin} ${compiler_args}): Begin"
    local args="${compiler_args} -x c -"
    echo "main;" | shell::exec ${compiler_bin} ${args} </dev/null 2>&1
    local retval="$?"
    print::debug "(${compiler_bin} ${compiler_args}): End (${retval})"

    return ${retval}
}

compiler::dump_defines() {
    local compiler_bin="${1}"; shift
    local compiler_args="${*}"

    compiler::_dump ${compiler_bin} "${compiler_args} -dM -E"
}

compiler::dump_flags() {
    local compiler_bin="${1}"; shift
    local compiler_args="${*}"

    compiler::_dump ${compiler_bin} "${compiler_args} -Q -v"
}

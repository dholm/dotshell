gcc::dump_defines() {
    local gcc_bin="${1}"; shift
    local gcc_args="${*}"

    print::debug "(${gcc_bin} ${gcc_args}): Begin"
    ${gcc_bin} ${gcc_args} -dM -E - </dev/null
    local retval="$?"
    print::debug "(${gcc_bin} ${gcc_args}): End (${retval})"
    return ${retval}
}

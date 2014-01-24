function gcc_dump_defines() {
    local gcc_bin="${1}"

    debug "${fn}(${args}): Begin"
    ${gcc_bin} -dM -E - </dev/null
    debug "${fn}(${args}): End ($?)"
}

function eval_safe
{
    local fn="${1}"; shift 1
    local args="${*}"

    debug "${fn}(${args}): Begin"
    eval ${fn} ${args}
    debug "${fn}(${args}): End ($?)"
}

function source_safe
{
    local file="${1}"

    if is_readable "${file}"
    then
        debug ". ${file}: Begin"
        source "${file}"
        debug ". ${file}: End"
    fi
}

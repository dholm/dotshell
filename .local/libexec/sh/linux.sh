debian::dpkg::build() {
    local usage="Usage:
 -c --clean       - Clean before build.
 --arch=<target>  - Cross-compile package for <target>.
 -h --help        - Print help.
"
    eval $(shell::args_parse "ch" "clean,arch:,help")

    local opts; typeset -A opts
    opts[clean]=false
    opts[arch]=$(uname -m)
    while true; do
        case "${1}" in
            -c|--clean) opts[clean]=true;;
            --arch) shift; opts[arch]="${1}";;
            -h|--help) print::info ${usage}; return 0;;
            --) shift; break;;
            *) print::error "Unknown option ${1}"; return 1;;
        esac
        shift
    done

    local build_args="-us -uc"
    if ! ${opts[clean]}; then
        print::debug "Not cleaning before build."
        build_args="${build_args} -nc"
    fi

    local build_cmd="$(path::to dpkg-buildpackage)"
    if [[ "$(uname -m)" != "${opts[arch]}" ]]; then
        print::debug "Cross compiling for ${opts[arch]}."
        build_cmd="$(path::to debuild)"
        build_args="-a${opts[arch]}"
    fi

    local build_env; build_env=( DEB_BUILD_OPTIONS=nocheck )
    shell::exec_env $(shell::as_array build_env) ${build_cmd} ${build_args}
}

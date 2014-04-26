python::syspip() {
    local args="${*}"
    local pipenv; pipenv=( PIP_REQUIRE_VIRTUALENV=false )

    shell::exec_env $(shell::as_array pipenv) $(path::to pip) ${args}
}

python::_site_path() {
    local python="${1}"

    local version="$(${python} --version 2>&1)"
    version="$(string::word 2 "${version}")"
    version="$(compat::version_norm "1.0" "${version}")"

    echo "python${version}/site-packages"
}

python::setup() {
    export VIRTUALENV_DISTRIBUTE=true

    if os::is_darwin && path::has_binary brew; then
        local libdir="$(homebrew::prefix)/lib"

        local site_packages="${libdir}/$(python::_site_path python)"
        if file::is_directory ${site_packages}; then
            export PYTHONPATH="${site_packages}:${PYTHONPATH}"
        fi

        local site3_packages="${libdir}/$(python::_site_path python3)"
        if file::is_directory ${site3_packages}; then
            export PYTHON3PATH="${site3_packages}:${PYTHON3PATH}"
        fi
    fi

    if path::has_binary pip; then
        export PIP_REQUIRE_VIRTUALENV=true
        export PIP_DOWNLOAD_CACHE="$HOME/.cache/pip"
    fi
}
shell::eval python::setup

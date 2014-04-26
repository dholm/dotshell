python::path() {
    local version=$(( ${1} )); shift

    local pypath="\${PYTHON${version}PATH}"
    eval echo ${pypath}
}

python::exec_python_version() {
    local version=$(( ${1} )); shift
    local args="${*}"

    local pyenv; pyenv=( PYTHONPATH="$(python::path ${version})" )
    local pybin="$(path::to python${version})"
    shell::exec_env $(shell::as_array pyenv) ${pybin} ${args}
}

python::exec_pip_version() {
    local version=$(( ${1} )); shift
    local args="${*}"

    local pipenv; pipenv=(
        PIP_REQUIRE_VIRTUALENV=false
        PYTHONPATH="$(python::path ${version})"
    )
    local pipbin="$(path::to pip${version})"
    shell::exec_env $(shell::as_array pipenv) ${pipbin} ${args}
}

python::_site_path() {
    local python="${1}"

    local version="$(${python} --version 2>&1)"
    version="$(string::word 2 "${version}")"
    version="$(compat::version_norm "1.0" "${version}")"

    echo "python${version}/site-packages"
}

python::_setup_darwin() {
    if path::has_binary brew; then
        local libdir="$(homebrew::prefix)/lib"

        local site2_packages="${libdir}/$(python::_site_path $(path::to python))"
        if file::is_directory ${site2_packages}; then
            export PYTHON2PATH="${site2_packages}:${PYTHON2PATH}"
        fi

        local site3_packages="${libdir}/$(python::_site_path $(path::to python3))"
        if file::is_directory ${site3_packages}; then
            export PYTHON3PATH="${site3_packages}:${PYTHON3PATH}"
        fi
    fi
}

python::_setup_pip() {
    export PIP_REQUIRE_VIRTUALENV=true
    export PIP_DOWNLOAD_CACHE="$HOME/.cache/pip"

    alias::add syspip2 "python::exec_pip_version 2"
    alias::add syspip3 "python::exec_pip_version 3"

    alias::add syspip syspip2
}

python::setup() {
    export VIRTUALENV_DISTRIBUTE=true

    export PYTHON2PATH
    export PYTHON3PATH

    os::is_darwin && python::_setup_darwin
    path::has_binary pip && python::_setup_pip

    alias::add python2 "python::exec_python_version 2"
    alias::add python3 "python::exec_python_version 3"

    # Make Python 2 the default.
    alias::add python python2
}
shell::eval python::setup

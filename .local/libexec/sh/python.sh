python::syspip() {
    local args="${*}"
    local pipenv=( PIP_REQUIRE_VIRTUALENV=false )

    shell::exec_env $(shell::as_array pipenv) $(path::to pip) ${args}
}

python::setup() {
    export VIRTUALENV_DISTRIBUTE=true

    if os::is_darwin && path::has_binary brew; then
        export PYTHONPATH="$(brew --prefix)/lib/python2.7/site-packages:${PYTHONPATH}"
    fi

    if path::has_binary pip; then
        export PIP_REQUIRE_VIRTUALENV=true
        export PIP_DOWNLOAD_CACHE="$HOME/.cache/pip"
    fi
}
shell::eval python::setup

homebrew::prefix() {
    local args="--prefix"
    shell::exec brew ${args}
}

homebrew::package_prefix() {
    local package="${1}"

    local args="--prefix ${package}"
    shell::exec brew ${args}
}

homebrew::package_installed() {
    local package="${1}"

    homebrew::package_prefix ${package} &>/dev/null
}

homebrew::setup() {
    local brew_prefix="$(brew --prefix)"
    path::prepend "${brew_prefix}/bin"
    path::prepend "${brew_prefix}/sbin"

    # Stop running update on every command and stashing modified formulas.
    export HOMEBREW_DEVELOPER=1

    export MANPATH="${brew_prefix}/share/man:${MANPATH}"

    if os::is_darwin && homebrew::package_installed libxml2; then
        local libxml2_prefix="$(homebrew::package_prefix libxml2)"
        export PKG_CONFIG_PATH="${libxml2_prefix}/lib/pkgconfig:${PKG_CONFIG_PATH}"
        export ACLOCAL_PATH="${libxml2_prefix}/share/aclocal:${ACLOCAL_PATH}"
    fi

    if brew command command-not-found-init &>/dev/null; then
        shell::eval "$(brew command-not-found-init)"
    fi
}
shell::eval homebrew::setup

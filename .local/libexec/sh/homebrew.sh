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
    path::prepend "$brew_prefix/bin"
    path::prepend "$brew_prefix/sbin"

    local packages; packages=( $(fn::filter 'homebrew::package_installed $1' \
        ruby python python3 go) )
    for package in ${packages[@]}; do
        path::prepend "$(homebrew::package_prefix ${package})/bin"
    done

    if homebrew::package_installed libxml2; then
        local libxml2_prefix="$(homebrew::package_prefix libxml2)"
        export PKG_CONFIG_PATH="${libxml2_prefix}/lib/pkgconfig:${PKG_CONFIG_PATH}"
        export ACLOCAL_PATH="${libxml2_prefix}/share/aclocal:${ACLOCAL_PATH}"
    fi
}
shell::eval homebrew::setup

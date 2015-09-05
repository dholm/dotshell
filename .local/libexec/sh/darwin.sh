darwin::package_is_installed() {
    local name="${1}"

    shell::exec pkgutil --pkg-info ${name} &>/dev/null
}

darwin::package_list() {
    shell::exec pkgutil --packages
}

darwin::package_info() {
    local name="${1}"

    if ! darwin::package_is_installed ${name}; then
        print::error "Package ${1} is not installed!"
        return 1
    fi

    echo "* Summary"
    shell::exec pkgutil --pkg-info ${name}
    echo "* Files"
    shell::exec pkgutil --files ${name}
}

darwin::package_owner() {
    local path="${1}"

    shell::exec pkgutil --file-info ${path}
}

darwin::setup() {
    path::prepend /usr/texbin
    path::prepend /opt/X11/bin

    local server_prefix="/Applications/Server.app/Contents/ServerRoot"
    path::prepend "$server_prefix/bin"
    path::prepend "$server_prefix/sbin"
}
shell::eval darwin::setup

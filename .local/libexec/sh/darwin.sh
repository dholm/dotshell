darwin::package::is_installed() {
    local name="${1}"

    shell::exec pkgutil --pkg-info "\"${name}\"" &>/dev/null
}

darwin::package::list() {
    shell::exec pkgutil --packages
}

darwin::package::files() {
    local name="${1}"

    if ! darwin::package::is_installed "${name}"; then
        print::error "Package ${name} is not installed!"
        return 1
    fi

    local volume="$(pkgutil --pkg-info "${name}" | egrep '^volume:' | cut -d' ' -f 2-)"
    local location="$(pkgutil --pkg-info "${name}" | egrep '^location:' | cut -d' ' -f 2-)"
    while read -r file; do
        echo "${volume}${location}/${file}"
    done <<< $(pkgutil --only-files --files "${name}")
}

darwin::package::directories() {
    local name="${1}"

    if ! darwin::package::is_installed "${name}"; then
        print::error "Package ${name} is not installed!"
        return 1
    fi

    local volume="$(pkgutil --pkg-info "${name}" | egrep '^volume:' | cut -d' ' -f 2-)"
    local location="$(pkgutil --pkg-info "${name}" | egrep '^location:' | cut -d' ' -f 2-)"
    while read -r file; do
        echo "${volume}${location}/${file}"
    done <<< $(pkgutil --only-dirs --files "${name}")
}

darwin::package::info() {
    local name="${1}"

    if ! darwin::package::is_installed "${name}"; then
        print::error "Package ${name} is not installed!"
        return 1
    fi

    echo "* Summary"
    shell::exec pkgutil --pkg-info "\"${name}\""
    echo "* Files"
    darwin::package::files "${name}"
}

darwin::package::owner() {
    local path="${1}"

    shell::exec pkgutil --file-info "\"${path}\""
}

darwin::package::uninstall() {
    local name="${1}"

    if ! darwin::package::is_installed "${name}"; then
        print::error "Package ${name} is not installed!"
        return 1
    fi

    while read -r file; do
        sudo rm -f "${file}"
    done <<< $(darwin::package::files "${name}")

    while read -r file; do
        sudo rmdir "${file}"
    done <<< $(darwin::package::directories "${name}")

    sudo pkgutil --forget "${name}"
}

darwin::setup() {
    path::prepend /usr/texbin
    path::prepend /opt/X11/bin

    local server_prefix="/Applications/Server.app/Contents/ServerRoot"
    path::prepend "$server_prefix/bin"
    path::prepend "$server_prefix/sbin"
}
shell::eval darwin::setup

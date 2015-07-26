go::setup() {
    if os::is_darwin; then
        export GOROOT="$(go env GOROOT)"
    else
        export GOROOT="${HOME}/.local/go"
        path::prepend "${GOROOT}/bin"
    fi

    export GOPATH="${HOME}/Projects/go"
    path::prepend "${GOPATH}/bin"
}
shell::eval go::setup

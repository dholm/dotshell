go::setup() {
    if os::is_darwin; then
        export GOROOT="$(go env GOROOT)"
    fi

    export GOPATH="${HOME}/Projects/go"
    path::prepend "${GOPATH}/bin"
}
shell::eval go::setup

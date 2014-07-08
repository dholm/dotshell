go::setup() {
    export GOROOT="${HOME}/.local/go"
    path::prepend "${GOROOT}/bin"

    export GOPATH="${HOME}/Projects/go"
    path::prepend "${GOPATH}/bin"
}
shell::eval go::setup

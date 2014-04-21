ocaml::setup() {
    if path::has_binary opam; then
        shell::eval $(opam config env)
    fi
}
shell::eval ocaml::setup

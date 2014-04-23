R::setup() {
    # R user library path.
    export R_LIBS_USER="${HOME}/.local/lib/R/site-library"

    # Set R command history.
    export R_HISTFILE="${HOME}/.Rhistory"
    export R_HISTSIZE=100000
}
shell::eval R::setup

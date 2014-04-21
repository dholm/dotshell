R::setup() {
    export R_HISTFILE="${HOME}/.Rhistory"
    export R_HISTSIZE=100000
}
shell::eval R::setup

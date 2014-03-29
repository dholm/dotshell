perl::local_lib::setup() {
    local arch_name="$(perl -MConfig -e'print $Config{archname}')"

    export PERL_LOCAL_LIB_ROOT="${HOME}/.local"
    export PERL_MB_OPT="--install_base ${PERL_LOCAL_LIB_ROOT}"
    export PERL_MM_OPT="INSTALL_BASE=${PERL_LOCAL_LIB_ROOT} LIB=${PERL_LOCAL_LIB_ROOT}/lib"
    export PERL_MM_OPT="${PERL_MM_OPT} INSTALLSITEMAN1DIR=${PERL_LOCAL_LIB_ROOT}/share/man/man1"
    export PERL_MM_OPT="${PERL_MM_OPT} INSTALLSITEMAN3DIR=${PERL_LOCAL_LIB_ROOT}/share/man/man3"
    export PERL5LIB="${PERL_LOCAL_LIB_ROOT}/lib/perl5/${arch_name}:${PERL_LOCAL_LIB_ROOT}/lib/perl5"
}

perl::setup() {
    path::prepend "${HOME}/perl5/bin"

    shell::eval perl::local_lib::setup

    local perlbrew_init="${HOME}/perl5/perlbrew/etc/bashrc"
    if file::is_readable "${perlbrew_init}"; then
        $(shell::source "${perlbrew_init}")
    fi
}
shell::eval perl::setup

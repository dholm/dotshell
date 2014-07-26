profile::start() {
    local sed="sed -u"
    local date="date"
    if os::is_darwin; then
        sed="sed"
        date="/usr/local/bin/gdate"
    fi

    exec 3>&2 2> >(
        tee /tmp/${USER}-shellrc.${$}.log |
            ${sed} 's/^.*$/now/' |
            ${date} -f - +%s.%N >/tmp/${USER}-shellrc.${$}.tim
    )
    if shell::is_bash; then
        set -x
    elif shell::is_zsh; then
        setopt xtrace prompt_subst
    fi
}

profile::stop() {
    if shell::is_bash; then
        set +x
    elif shell::is_zsh; then
        unsetopt xtrace
    fi
    exec 2>&3 3>&-
    print::info "Profile written to /tmp/${USER}-shellrc.${$}."
}

profile::report() {
    local sample_file="${1%.*}"

    paste <(
        while read tim ;do
            [ -z "$last" ] && last=${tim//.} && first=${tim//.}
            crt=000000000$((${tim//.}-10#0$last))
            ctot=000000000$((${tim//.}-10#0$first))
            printf "%12.9f %12.9f\n" \
                ${crt:0:${#crt}-9}.${crt:${#crt}-9} \
                ${ctot:0:${#ctot}-9}.${ctot:${#ctot}-9}
            last=${tim//.}
      done < ${sample_file}.tim
    ) ${sample_file}.log
}

if ((PROFILE)); then
    profile::start
fi

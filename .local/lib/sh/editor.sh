export EDITOR=""

editor::emacs::basic() {
    local emacs_basic="-Q --load ${HOME}/.emacs.d/basic.el"
    local emacs_args="-nw ${emacs_basic}"
    echo $(path::to emacs) ${emacs_args}
}

editor::emacsclient() {
    if os::is_darwin; then
        # When exiting emacsclient on OSX Emacs crashes.
        editor::emacs::basic
    else
        local alternate_editor="$(path::to emacs)"
        local emacsclient_args="-nw -a \"${alternate_editor}\""
        echo $(path::to emacsclient) ${emacsclient_args}
    fi
}

editor::vim() {
    echo $(path::to vim)
}

editor::nano() {
    echo $(path::to nano)
}

editor::setup() {
    if path::has_binary emacsclient; then
        EDITOR=$(editor::emacsclient)
    elif path::has_binary emacs; then
        EDITOR=$(editor::emacs::basic)
    elif path::has_binary vim; then
        EDITOR=$(editor::vim)
    elif path::has_binary nano; then
        EDITOR=$(editor::nano)
    else
        print::error "No editor found!"
    fi
}

editor() {
    local args="${*}"
    shell::exec ${EDITOR} ${args}
}

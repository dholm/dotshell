keyboard::layout() {
    if [[ -n "${DISPLAY}" ]]; then
        local x11_keymap="$(shell::exec setxkbmap -print)"
        print::debug "X11 keymap: ${x11_keymap}"
        if [[ "${?}" -ne 0 ]]; then
            print::error "Failed to print X11 keymap!"
            return 1
        fi
        local x11_symbols="$(echo ${x11_keymap} | grep xkb_symbols)"
        print::debug "X11 symbols: ${x11_symbols}"
        local layout="$(echo ${x11_symbols} | awk -F'+' '{print $2}')"
        echo "${layout}"
        return 0
    fi

    return 1
}

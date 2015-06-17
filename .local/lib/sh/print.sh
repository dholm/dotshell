print::pen_color() {
    local fg_bg="${1}"
    local color="${2}"

    case "${color}" in
        red) color=1;;
        green) color=2;;
        yellow) color=3;;
        blue) color=4;;
        pink) color=5;;
        cyan) color=6;;
        grey) color=7;;
    esac

    case "${fg_bg}" in
        fg) tput setaf ${color};;
        *) tput setab ${color};;
    esac
}

print::pen_style() {
    local style="${1}"

    case "${style}" in
        normal) tput sgr0;;
        standout) tput smso;;
        bold) tput bold;;
        dim) tput dim;;
        reverse) tput rev;;
        blink) tput blink;;
        underline) tput smul;;
        hidden) tput invis;;
    esac
}

print::error() {
    echo -e "\
$(print::pen_style bold)\
$(print::pen_color fg red)\
$(eval ${caller}):\
${*}\
$(print::pen_style normal)" 1>&2
}

print::warning() {
    echo -e "\
$(print::pen_color fg yellow)\
$(eval ${caller}):\
${*}\
${print::pen_style normal}" 1>&2
}

print::info() {
    echo -e "\
$(print::pen_color fg green)\
$(eval ${caller}):\
${*}\
$(print::pen_style normal)" 1>&2
}

print::debug() {
    if ((DEBUG)); then
        echo -e "\
$(print::pen_color fg grey)\
$(eval ${caller}):\
${*}\
$(print::pen_style normal)" 1>&2
    fi
}

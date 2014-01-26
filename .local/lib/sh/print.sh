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

print::pen_format() {
    local format="${1}"

    case "${format}" in
        normal) tput sgr0;;
        bold) tput bold;;
        underline) tput smul;;
    esac
}

print::error() {
    echo -e "\
$(print::pen_format bold)\
$(print::pen_color fg red)\
$(eval ${caller}):\
${*}\
$(print::pen_format normal)"
}

print::warning() {
    echo -e "\
$(print::pen_color fg yellow)\
$(eval ${caller}):\
${*}\
${print::pen_format normal}"
}

print::info() {
    echo -e "\
$(print::pen_color fg green)\
$(eval ${caller}):\
${*}\
$(print::pen_format normal)"
}

print::debug() {
    if ((DEBUG)); then
        echo -e "\
$(print::pen_color fg grey)\
$(eval ${caller}):\
${*}\
$(print::pen_format normal)"
    fi
}

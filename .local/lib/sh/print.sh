function pen_color
{
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

function pen_format
{
    local format="${1}"

    case "${format}" in
        normal) tput sgr0;;
        bold) tput bold;;
        underline) tput smul;;
    esac
}

function error { echo -e "$(pen_format bold)$(pen_color fg red)${*}$(pen_format normal)"; }
function warning { echo -e "$(pen_color fg yellow)${*}${pen_format normal}"; }
function info { echo -e "$(pen_color fg green)${*}$(pen_format normal)"; }
function debug { ((DEBUG)) && echo -e "$(pen_color fg grey)${*}$(pen_format normal)"; }

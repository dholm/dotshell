typeset _url_pattern='^(([a-z]{3,5})://)?((([^:\/]+)(:([^@\/]*))?@)?([^:\/?]+)(:([0-9]+))?)(\/[^?]*)?(\?[^#]*)?(#.*)?$'
typeset _url_protocol=2
typeset _url_address=3
typeset _url_user=5
typeset _url_password=7
typeset _url_host=8
typeset _url_port=10
typeset _url_path=11
typeset _url_query=12
typeset _url_fragment=13

_url::parse() {
    local url="${1}"

    if [[ ! "${url}" =~ ${_url_pattern} ]]; then
        return 1
    fi

    return 0
}

_url::get_component() {
    local url="${1}"
    local component="${2}"

    if _url::parse ${url}; then
        if shell::is_zsh; then
            echo "${match[${component}]}"
        elif shell::is_bash; then
            echo "${BASH_REMATCH[${component}]}"
        fi
    fi
}

url::is_valid() {
    local url="${1}"
    _url::parse ${url}
}

url::get_protocol() {
    local url="${1}"
    _url::get_component ${url} ${_url_protocol}
}

url::get_user() {
    local url="${1}"
    _url::get_component ${url} ${_url_user}
}

url::get_host() {
    local url="${1}"
    _url::get_component ${url} ${_url_host}
}

url::get_port() {
    local url="${1}"
    _url::get_component ${url} ${_url_port}
}

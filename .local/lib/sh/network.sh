network::ip::_public() {
    local url="${1}"

    if path::has_binary curl; then
        shell::exec curl --silent "${url}"
    elif path::has_binary wget; then
        shell::exec wget --quiet --output-document - "${url}"
    else
        return -1
    fi
}

network::ip::public() {
    local usage="Usage:
 -4 --ipv4  - Query the IPv4 address.
 -6 --ipv6  - Query the IPv6 address.
 -h --help  - Print help.
"
    eval $(shell::args_parse "46h" "ipv4,ipv6,help")

    local host="icanhazip.com"
    while true; do
        case "${1}" in
            -4|--ipv4) host="ipv4.icanhazip.com";;
            -6|--ipv6) host="ipv6.icanhazip.com";;
            -h|--help) print::info ${usage}; return 0;;
            --) shift; break;;
            *) print::error "Unknown option: ${1}"; return 1;;
        esac
        shift
    done

    network::ip::_public "${host}"
}

network::dns::flush() {
    if os::is_darwin; then
        shell::exec dscacheutil -flushcache
        process::hangup --privileged mDNSResponder
    elif os::is_linux; then
        if service::has dns-clean; then
            service::restart dns-clean
        elif service::has nscd; then
            service::restart nscd
        elif service::has dnsmasq; then
            service::restart dnsmasq
        elif service::has bind; then
            service::restart bind
        fi
    fi
}

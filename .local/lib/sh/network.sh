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

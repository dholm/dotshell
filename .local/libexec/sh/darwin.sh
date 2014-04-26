darwin::setup() {
    path::prepend /usr/texbin
    path::prepend /opt/X11/bin

    local server_prefix="/Applications/Server.app/Contents/ServerRoot"
    path::prepend "$server_prefix/bin"
    path::prepend "$server_prefix/sbin"
}
shell::eval darwin::setup

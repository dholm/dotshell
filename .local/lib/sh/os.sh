os::is_linux() {
    test "$(uname)" = "Linux"
}

os::is_darwin() {
    test "$(uname)" = "Darwin"
}

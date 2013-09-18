function is_linux
{
    test "$(uname)" = "Linux"
}

function is_darwin
{
    test "$(uname)" = "Darwin"
}

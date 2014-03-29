fontconfig::setup() {
    local infinality_settings="$HOME/.dotfiles/external/fontconfig-ultimate/freetype/infinality-settings.sh"
    $(shell::source "${infinality_settings}")
}
shell::eval fontconfig::setup

export _package_env; _package_env=(
    CFLAGS="'-I${HOME}/.local/include -L${HOME}/.local/lib -Wl,-rpath=${HOME}/.local/lib'"
    LDFLAGS="'-L${HOME}/.local/lib -Wl,-rpath=${HOME}/.local/lib'"
)

package::configure() {
    local args="${*}"

    local package_prefix="$(dirname ${PWD})"
    local configure_args; configure_args=(
        --prefix="${package_prefix}"
        --disable-dependency-tracking
        --disable-debug
        --disable-dependency-tracking
        ${args}
    )

    shell::exec_env $(shell::as_array _package_env) ./configure ${configure_args[@]}
}

package::cmake() {
    local args="${*}"

    local package_prefix="$(dirname ${PWD})"
    local cmake_args; cmake_args=(
        -DCMAKE_INSTALL_PREFIX:PATH="${package_prefix}"
        -DBUILD_WITH_INSTALL_RPATH=TRUE
        ${args}
    )

    shell::exec_env $(shell::as_array _package_env) cmake ${cmake_args}
}

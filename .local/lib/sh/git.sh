vcs::git::subpatch_list() {
    local base_path="${1}"

    local git_args="log --oneline --reverse -- ${base_path}"
    local reflist="$(shell::exec $(path::to git) ${git_args})"
    if [ "${?}" -ne 0 ]; then
        print::error "Failed to generate list of refspecs for ${base_path}!"
        return 1
    fi

    local cut_args="-d ' ' -f 1 -"
    echo "${reflist}" | while read refspec msg; do
        echo "${refspec}"
    done
    return ${?}
}

vcs::git::subpatch_generate() {
    local base_path="${1}"
    local out_path="${2}"

    local refspec_list; refspec_list=( $(vcs::git::subpatch_list ${base_path}) )
    local git_args="log -p --pretty=email --stat -m"
    for refspec in ${refspec_list[@]}; do
        local args="${git_args} ${refspec}~1..${refspec} -- ${base_path}"
        local patch="$(shell::exec $(path::to git) ${args})"
        if [ "${?}" -ne 0 ]; then
            print::warning "Failed to generate patch for ${refspec}!"
            continue
        fi
        local patch_file="${out_path}/${refspec}.patch"
        echo ${patch} >${patch_file}
    done

    echo ${refspec_list} >${out_path}/patch.list
}

vcs::git::subpatch_apply() {
    local patch_list_file="${1}"
    local strip_prefix="${2}"

    local patch_path="$(shell::exec $(path::to dirname) ${patch_list_file})"
    local patch_list; patch_list=( $(cat "${patch_list_file}") )
    local git_args="am -3 -p${strip_prefix}"
    for refspec in ${patch_list[@]}; do
        local patch_file="${patch_path}/${refspec}.patch"
        shell::exec $(path::to git) ${git_args} ${patch_file}
        if [ "${?}" -ne 0 ]; then
            print::error "Failed to apply ${patch_file}!"
            return 1
        fi
    done
    return 0
}

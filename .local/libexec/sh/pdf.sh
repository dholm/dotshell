pdf::pages() {
    local pdf="${1}"
    shell::exec podofocountpages -s "${pdf}"
}

pdf::to_eps() {
    local pdf="${1}"

    local name="$(basename "${pdf}")"
    local pages=$(( $(pdf::pages "${pdf}") ))
    local cropped=".${name%.*}.tmp.pdf"

    shell::exec pdfcrop "${pdf}" "${cropped}" >/dev/null
    for (( page = 1; page <= ${pages}; page++ )); do
        shell::exec pdftops -eps -level3 -f ${page} -l ${page} "${cropped}" "${name%.*}.${page}.eps"
    done
    shell::exec rm -f "${cropped}"
}

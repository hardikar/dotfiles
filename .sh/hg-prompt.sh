# My attempt to hobble together a reasonable hg prompt

__hg_setup() {
    # Determine the shell type - bash/zsh
    if [[ $SHELL == *zsh* ]]; then
        READ_ARRAY_OPT="-A"
    else
        READ_ARRAY_OPT="-a"
    fi
}

__hg_ps1() {
    __hg_setup

    local -i changed        # count of items that need to be committed
    local -i untracked      # count of items not in version control
    local -i staged         # count of items staged for commit
    local branch            # name of current branch or "" if not gathered
    local error             # if set, show error to user

    local line
    local commit=""
    while IFS= read -r line ; do
        if [[ "${line:0:2}" = "xx" ]]; then
            return 1
        fi

        local field="${line%%: *}"   # remove everything after first ': '
        local value="${line#*: }"    # remove everything before first ': '
        if [[ "${field}" = "branch" ]]; then
            branch="${value}"
        elif [[ "${field}" = "commit" ]]; then
            commit="${value}"
        fi
        #Note: Commit message is indented so it won't ever match a field.
    done < <(hg summary 2>/dev/null || echo -e "xx: $?")


    # both should *always* be present, if not assume bad output
    if [[ -z "${branch}" || -z "${commit}" ]]; then
        error="unexpected hg summary output"
        return 0
    fi

    # commit: 1 modified, 1 added, 2 unknown (info)
    # +----+  +-----------------------------------+ field value
    #         +--------+ +------+ +---------------+ chunks
    #         + +------+  + +---+  + +-----+ +----+ parts
    local chunks chunk
    IFS="," read -r $READ_ARRAY_OPT chunks <<< "${commit}"
    for chunk in "${chunks[@]}"; do
        local parts count kind
        IFS=" " read -r $READ_ARRAY_OPT parts <<< "${chunk}"
        count="${parts[1]:-0}"
        kind="${parts[2]:-""}"
        case "${kind}" in
            modified|added|renamed|removed) ((changed += count)) ;;
            unknown|deleted)  ((untracked += count)) ;;
        esac
    done

    local hgstate
    hgstate=""
    (( untracked )) && hgstate+="%${untracked}"
    (( changed ))   && hgstate+="*${changed}"
    (( staged ))    && hgstate+="+${staged}"
    if [[ -z "${hgstate}" ]]; then
        echo ":(${branch})"
    else
        echo ":(${branch} ${hgstate})"
    fi
    return 0
}
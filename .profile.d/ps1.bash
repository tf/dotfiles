# jj/git prompt for bash

# Color codes for use in command substitution (use \001 \002 instead of \[ \])
__jj_color_yellow=$'\001\033[01;33m\002'
__jj_color_reset=$'\001\033[00m\002'

__jj_ps1() {
    # Quick check: are we in a jj repo?
    jj root &>/dev/null || return 1

    local jj_opts="--ignore-working-copy --no-pager"

    # Get info using a simple concatenated format (not tab-separated to avoid parsing issues)
    local change_id bookmark is_empty

    change_id=$(jj log $jj_opts -r @ --no-graph -T 'change_id.shortest()' 2>/dev/null) || return 1
    bookmark=$(jj log $jj_opts -r @ --no-graph -T 'if(bookmarks, bookmarks.join(","), "")' 2>/dev/null)
    is_empty=$(jj log $jj_opts -r @ --no-graph -T 'if(empty, "yes", "")' 2>/dev/null)

    # Find the closest reference: either a bookmark on @, nearest ancestor bookmark, or trunk
    local distance="" ref_name="" ref_display=""

    if [[ -n "$bookmark" ]]; then
        # Bookmark directly on @
        ref_name="${bookmark%%,*}"
        ref_display="$ref_name"
        distance=""
    else
        # Compare distance to trunk vs closest bookmark ancestor
        local trunk_dist=999999 bookmark_dist=999999 ancestor_bookmark=""

        # Distance from trunk
        trunk_dist=$(jj log $jj_opts -r 'trunk()::@ ~ trunk()' --no-graph -T '"x"' 2>/dev/null | wc -c)

        # Find closest ancestor with a bookmark and its distance
        ancestor_bookmark=$(jj log $jj_opts -r 'heads(::@ & bookmarks())' --no-graph -T 'bookmarks.join(",")' 2>/dev/null)
        if [[ -n "$ancestor_bookmark" ]]; then
            ancestor_bookmark="${ancestor_bookmark%%,*}"
            ancestor_bookmark="${ancestor_bookmark%\*}"  # Strip trailing * (jj display indicator)
            bookmark_dist=$(jj log $jj_opts -r "$ancestor_bookmark::@ ~ $ancestor_bookmark" --no-graph -T '"x"' 2>/dev/null | wc -c)
        fi

        # Pick the closer one
        if [[ $trunk_dist -le $bookmark_dist ]]; then
            ref_name="trunk()"
            ref_display="trunk"
            [[ $trunk_dist -gt 0 ]] && distance="+$trunk_dist"
        else
            ref_name="$ancestor_bookmark"
            ref_display="$ancestor_bookmark"
            [[ $bookmark_dist -gt 0 ]] && distance="+$bookmark_dist"
        fi
    fi

    # Build the prompt
    local result=""

    # Reference name with distance
    if [[ -n "$ref_display" ]]; then
        result="${ref_display}${distance} "
    fi

    # Change ID (highlight with yellow)
    result+="${__jj_color_yellow}${change_id}${__jj_color_reset}"

    # Empty indicator
    if [[ "$is_empty" == "yes" ]]; then
        result+="-"
    fi

    echo "[$result]"
}

__smart_vcs_ps1() {
    # Try jj first
    local jj_prompt
    jj_prompt=$(__jj_ps1 2>/dev/null)
    if [[ -n "$jj_prompt" ]]; then
        echo "$jj_prompt"
        return
    fi

    # Fall back to git
    __git_ps1 "[%s]" 2>/dev/null
}

# Save original PS1 if not already saved
if [[ -z "$__ORIG_PS1" ]]; then
    export __ORIG_PS1="$PS1"
fi

# Set the prompt with smart VCS detection
PS1='\[\033[01;37m\]${debian_chroot:+($debian_chroot)}\u@\h\[\033[00m\]:\w$(__smart_vcs_ps1)\$ '

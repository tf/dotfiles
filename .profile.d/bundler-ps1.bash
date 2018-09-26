__bundler_ps1 () {
    local g="$(__gitdir)"

    local yellow='\033[0;33m'
    local reset='\033[0m'

    if [ -n "$g" ]; then
        local c="$g/../.bundle/config"
        
        if [ -f "$c" ]; then
            local n="$(grep BUNDLE_LOCAL__ $c | wc -l)"

            if [ $n -gt 0 ]; then
                printf "$yellow[%s]$reset" "$n"
            fi
        fi
    fi
}

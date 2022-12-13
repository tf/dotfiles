_tfpass() {
    local tmp="$PASSWORD_STORE_DIR"
    PASSWORD_STORE_DIR=~/.tf-password-store
    _pass
    PASSWORD_STORE_DIR="$tmp"
}

complete -o filenames -F _tfpass tfpass

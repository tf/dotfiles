alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

alias em=emacsclient

function mkcd() {
  mkdir $1 && eval cd $1
}

alias r=redmine

alias b='bundle exec'

alias git='LANG=en_US git'
alias g='git status'
alias gr='git gr'

alias pr='git push origin && hub pull-request -o'
alias gup='git co master && git pull upstream master && git fetch -p'

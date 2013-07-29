alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

alias apt-i='sudo apt-get install'
alias apt-r='sudo apt-get remove'
alias apt-ud='sudo apt-get update'
alias apt-ug='sudo apt-get upgrade'

alias m=make
alias em=emacsclient

function mkcd() {
  mkdir $1 && eval cd $1
}

alias r=redmine
alias rdm=redmine
alias bb=bookbuild

alias rbenv192='rbenv shell 1.9.2-p320'
alias rbenv193='rbenv shell 1.9.3-p194'
alias rbenvg192='rbenv global 1.9.2-p320'
alias rbenvg193='rbenv global 1.9.3-p194'

alias b='bundle exec'

alias npmll='npm ls|grep ">"'

alias g='git status'
alias gr='git gr'

# General purpose
alias py="python3"
alias tf="terraform"
alias calc="bc -l"
alias mkdir="mkdir -pv"
alias rm="rm -I --preserve-root"
alias update="sudo apt update && sudo apt upgrade"
alias ping="ping -c 5"

if [[ -v WSL_DISTRO_NAME ]]; then
    function clip() {
        cat $1 | clip.exe
    }
fi

if [[ -x "$(command -v podman)" ]]; then
    alias docker="podman"
fi

docker_aliases() {
    alias jupyter="docker run --rm -p 8888:8888 -e JUPYTER_ENABLE_LAB=yes -v ${PWD}:/home/jovyan/work docker.io/jupyter/minimal-notebook"
    alias jupyterStop="docker stop $(docker ps -a -f "ancestor=jupyter/minimal-notebook" -q)"

    alias dk="docker"
    alias dkl="docker logs"
    alias dklf="docker logs -f"
    alias dki="docker images"
    alias dkc="docker container"
    alias dkrm="docker rm"

    alias dke="docker exec"
    dksh() {
        docker exec -it $1 /bin/sh
    }

    alias dkps="docker ps --format '{{.ID}} ~ {{.Names}} ~ {{.Status}} ~ {{.Image}}'"
    alias dktop="docker stats --format 'table {{.Container}}\t{{.Name}}\t{{.CPUPerc}}\t{{.MemPerc}}\t{{.NetIO}}\t{{.BlockIO}}'"
    dkstats() {
        if [[ $# -eq 0 ]]; then
            docker stats --no-stream
        else
            docker stats --no-stream | grep $1
        fi
    }

    alias dkprune="docker system prune -af"
}
# Docker
if [[ -x "$(command -v docker)" ]]; then
    docker_aliases
fi

# Git
alias g="git"

alias ga="git add"
alias gaa="git add --all"

alias gc="git commit -v -m"
alias gc!="git commit -v --amend"

alias gaac="gaa && gc"

alias gb="git branch --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(contents:subject) %(color:green)(%(committerdate:relative)) [%(authorname)]' --sort=-committerdate"
alias gs="git status -sb"

alias gst="git stash"
alias gsta="git stash apply"
alias gstp="git stash pop"

alias gco="git checkout"

alias gd="git diff"

alias gl="git pull"

alias glog="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset'"

alias gm="git merge"

alias gp="git push"

alias grb="git rebase"
alias grba="git rebase --abort"
alias grbc="git rebase --continue"

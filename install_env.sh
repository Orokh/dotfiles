#! /bin/bash

SCRIPT_DIR="$( dirname -- "${BASH_SOURCE[0]}" )"

source "${SCRIPT_DIR}/_libs/logging.sh"
source "${SCRIPT_DIR}/_libs/steps.sh"

# Env
DOTFILES_DIR="$HOME"/dotfiles
ZSH_CUSTOM_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
ZSH_PLUGINS_DIR="${ZSH_CUSTOM_DIR}/plugins"
ZSH_THEMES_DIR="${ZSH_CUSTOM_DIR}/themes"

APT_EXTRA_REPOS=()

APT_DEPS=(
    build-essential 
    libcairo2-dev 
    libdbus-glib-1-dev 
    libgirepository1.0-dev 
    libsystemd-dev 
    pkg-config 
    python3-pip
    ripgrep 
    stow
)

APT_TO_REMOVE=(
    python3
    python3.10
    python3-minimal
    python3.10-minimal
)

BREW_INSTALLS=(
    asdf
    bat
    exa
    fish
    fzf
    git-delta
    jq
    neovim
    podman
    python
    shellcheck
    starship
    tldr
    tmux
    unzip
    zoxide
    zsh
)

PIP_INSTALLS=(
    pip
    black
    pip-review
    pre-commit
    sqlfluff
)

STOW_DIRS=(
    fish
    fzf
    git
    nvim
    starship
    tmux
    zsh
)

sudo --validate

steps::sys_setup "${APT_EXTRA_REPOS[@]}"

steps::deps "${APT_DEPS[@]}"

steps::clean_preinstalled "${APT_TO_REMOVE[@]}"

steps::brew_installs "${BREW_INSTALLS[@]}"

steps::pip_installs "${PIP_INSTALLS[@]}"

steps::setup_stow "${STOW_DIRS[@]}"

steps::ssh_config

steps::setup_shell

logging::success "Installation complete."

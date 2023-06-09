#! /bin/bash

# Env
DOTFILES_DIR="$HOME"/dotfiles
ZSH_CUSTOM_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
ZSH_PLUGINS_DIR="${ZSH_CUSTOM_DIR}/plugins"
ZSH_THEMES_DIR="${ZSH_CUSTOM_DIR}/themes"

EXTRA_REPOS=(
    "ppa:fish-shell/release-3"
)

CLIP_DEPS=(
    build-essential 
    libcairo2-dev 
    libdbus-glib-1-dev 
    libfuse2 
    libgirepository1.0-dev 
    libsystemd-dev 
    pkg-config 
    python3-pip
    ripgrep 
    stow
    unzip 
)

CLI_TOOLS=(
    exa
    fish
    jq
    shellcheck
    tmux
    unzip
    zsh
)

BREW_INSTALLS=(
    bat
    neovim
    fzf
    starship
    zoxide
)

PIP_DEPS=(
    pip-review
)

PIP_TOOLS=(
    black
    sqlfluff
)

STOW_DIRS=(
    fish
    fzf
    git
    nvim
    tmux
    zsh
)

echo "== SYS == Upgrade packages"
sudo apt -qq update && apt -qq upgrade -y

echo "== SYS == Adding extra repos"
sudo apt-add-repository -qq "${EXTRA_REPOS[@]}"

echo "== CLI == Installing dependencies"
sudo apt -qq install -y "${CLIP_DEPS[@]}"

echo "== CLI == Installing Homebrew"
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

echo "== CLI == Installing tools"
sudo apt -qq install -y "${CLI_TOOLS[@]}"
brew install -q "${BREW_INSTALLS[@]}"

echo "== PIP == Installing dependencies"
pip install --quiet --upgrade "${PIP_DEPS[@]}"

echo "== PIP == Upgrade packages"
pip-review --auto --quiet

echo "== PIP == Installing tools"
pip install --quiet --upgrade "${PIP_TOOLS[@]}"

echo "== CFG == Stow configuration files"
pushd "${DOTFILES_DIR}" || exit
for dir in "${STOW_DIRS[@]}"; do
    echo "stow $dir"
    stow -D "${dir}"
    stow "${dir}"
done
popd || exit

echo "== ZSH == Install OMZ"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

echo "== ZSH == Install plugins"
mkdir -p "${ZSH_PLUGINS_DIR}"

rm -rf "${ZSH_PLUGINS_DIR}"/zsh-autosuggestions
rm -rf "${ZSH_PLUGINS_DIR}"/zsh-syntax-highlighting
rm -rf "${ZSH_PLUGINS_DIR}"/zsh-z
rm -rf "${ZSH_THEMES_DIR}"/powerlevel10k
git clone --quiet "https://github.com/zsh-users/zsh-autosuggestions.git" "${ZSH_PLUGINS_DIR}"/zsh-autosuggestions
git clone --quiet "https://github.com/zsh-users/zsh-syntax-highlighting.git" "${ZSH_PLUGINS_DIR}"/zsh-syntax-highlighting
git clone --quiet "https://github.com/agkozak/zsh-z" "${ZSH_PLUGINS_DIR}"/zsh-z
git clone --quiet --depth=1 "https://github.com/romkatv/powerlevel10k.git" "${ZSH_THEMES_DIR}"/powerlevel10k

echo "== Fish == Install Fisher"
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher

echo "== Fish == Install plugins"
fisher install kidonng/zoxide.fish

echo "== SSH == Create private key"
if [[ ! -d ~/.ssh ]]; then
    echo "== No existing config found. Generating key."
fi

echo "== Change shell"
shell_opts=(zsh fish)
select user_shell in "${shell_opts[@]}"; do
    chsh -s "$(which "${user_shell}")"
    break
done
chsh -s "$(which fish)"


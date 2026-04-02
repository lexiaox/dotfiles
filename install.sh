#!/usr/bin/env bash

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

backup_file() {
    local file="$1"
    if [[ -f "$file" || -d "$file" ]]; then
        local backup="${file}.backup.$(date +%Y%m%d_%H%M%S)"
        log_info "Backing up $file to $backup"
        cp -R "$file" "$backup"
    fi
}

create_symlink() {
    local source="$1"
    local target="$2"

    if [[ ! -e "$source" ]]; then
        log_warning "Source does not exist: $source"
        return 1
    fi

    if [[ -e "$target" && ! -L "$target" ]]; then
        backup_file "$target"
    fi

    mkdir -p "$(dirname "$target")"
    ln -sfn "$source" "$target"
    log_success "Linked $target -> $source"
}

require_command() {
    local name="$1"
    if ! command -v "$name" >/dev/null 2>&1; then
        log_error "Missing required command: $name"
        exit 1
    fi
}

ensure_oh_my_zsh() {
    local omz_dir="$HOME/.oh-my-zsh"

    if [[ -d "$omz_dir" ]]; then
        log_info "oh-my-zsh already installed at $omz_dir"
        return
    fi

    require_command git
    require_command curl
    require_command zsh

    log_info "Installing oh-my-zsh"
    RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c \
        "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

ensure_powerlevel10k() {
    local zsh_custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
    local theme_dir="$zsh_custom/themes/powerlevel10k"

    if [[ -d "$theme_dir" ]]; then
        log_info "powerlevel10k already installed at $theme_dir"
        return
    fi

    require_command git

    log_info "Installing powerlevel10k"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$theme_dir"
}

install_dotfiles() {
    log_info "Installing dotfiles"

    local dotfiles_dir
    dotfiles_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

    log_info "Installing shell configuration"
    create_symlink "$dotfiles_dir/.profile" "$HOME/.profile"
    ensure_oh_my_zsh
    ensure_powerlevel10k
    create_symlink "$dotfiles_dir/zsh/.zshrc" "$HOME/.zshrc"
    create_symlink "$dotfiles_dir/zsh/.p10k.zsh" "$HOME/.p10k.zsh"

    log_info "Installing Neovim configuration"
    create_symlink "$dotfiles_dir/nvim/init.vim" "$HOME/.config/nvim/init.vim"

    log_info "Installing SSH configuration"
    create_symlink "$dotfiles_dir/ssh/config" "$HOME/.ssh/config"

    log_info "Installing Git configuration"
    create_symlink "$dotfiles_dir/git/.gitconfig" "$HOME/.gitconfig"

    if [[ -d "$dotfiles_dir/bin" ]]; then
        if ! grep -Fq "$dotfiles_dir/bin" "$HOME/.profile" 2>/dev/null; then
            echo "export PATH=\"\$PATH:$dotfiles_dir/bin\"" >> "$HOME/.profile"
            log_success "Added $dotfiles_dir/bin to PATH"
        fi
    fi

    log_success "dotfiles installed"
    echo
    echo "Next steps:"
    echo "  source ~/.zshrc"
    echo "  nvim +PlugInstall +qall"
}

uninstall_dotfiles() {
    log_warning "Removing linked dotfiles"

    rm -f "$HOME/.profile"
    rm -f "$HOME/.zshrc"
    rm -f "$HOME/.p10k.zsh"
    rm -f "$HOME/.config/nvim/init.vim"
    rm -f "$HOME/.ssh/config"
    rm -f "$HOME/.gitconfig"

    log_info "oh-my-zsh and powerlevel10k directories are left intact"
    log_success "dotfiles uninstalled"
}

show_help() {
    echo "Usage: $0 [install|uninstall|help]"
}

main() {
    local action="${1:-install}"

    case "$action" in
        install)
            install_dotfiles
            ;;
        uninstall)
            uninstall_dotfiles
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            log_error "Unknown action: $action"
            show_help
            exit 1
            ;;
    esac
}

main "$@"

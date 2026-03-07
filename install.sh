#!/bin/bash

# ============================================
# Dotfiles 安装脚本
# ============================================

set -e  # 遇到错误时退出

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 日志函数
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

# 备份原有文件
backup_file() {
    local file="$1"
    if [[ -f "$file" || -d "$file" ]]; then
        local backup="${file}.backup.$(date +%Y%m%d_%H%M%S)"
        log_info "备份 $file 到 $backup"
        cp -r "$file" "$backup"
    fi
}

# 创建符号链接
create_symlink() {
    local source="$1"
    local target="$2"
    
    if [[ ! -e "$source" ]]; then
        log_warning "源文件不存在: $source"
        return 1
    fi
    
    # 如果目标已存在且不是符号链接，则备份
    if [[ -e "$target" && ! -L "$target" ]]; then
        backup_file "$target"
    fi
    
    # 创建目录（如果需要）
    mkdir -p "$(dirname "$target")"
    
    # 创建符号链接
    ln -sf "$source" "$target"
    log_success "创建符号链接: $target → $source"
}

# 主安装函数
install_dotfiles() {
    log_info "开始安装 dotfiles..."
    
    # 获取 dotfiles 目录
    DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    
    # 1. Shell 配置
    log_info "安装 Shell 配置..."
    create_symlink "$DOTFILES_DIR/.profile" "$HOME/.profile"
    create_symlink "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
    create_symlink "$DOTFILES_DIR/zsh/.p10k.zsh" "$HOME/.p10k.zsh"
    
    # 2. Neovim 配置
    log_info "安装 Neovim 配置..."
    create_symlink "$DOTFILES_DIR/nvim/init.vim" "$HOME/.config/nvim/init.vim"
    
    # 3. SSH 配置
    log_info "安装 SSH 配置..."
    create_symlink "$DOTFILES_DIR/ssh/config" "$HOME/.ssh/config"
    
    # 4. Git 配置
    log_info "安装 Git 配置..."
    create_symlink "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"
    
    # 5. 自定义脚本
    log_info "安装自定义脚本..."
    if [[ -d "$DOTFILES_DIR/bin" ]]; then
        # 将 bin 目录添加到 PATH（如果尚未添加）
        if [[ ! ":$PATH:" == *":$DOTFILES_DIR/bin:"* ]]; then
            echo "export PATH=\"\$PATH:$DOTFILES_DIR/bin\"" >> "$HOME/.profile"
            log_success "已将 $DOTFILES_DIR/bin 添加到 PATH"
        fi
    fi
    
    log_success "dotfiles 安装完成！"
    
    # 显示后续步骤
    echo ""
    echo "==========================================="
    echo "后续步骤："
    echo "1. 重新加载 Shell 配置："
    echo "   source ~/.zshrc"
    echo ""
    echo "2. Neovim 插件安装："
    echo "   nvim +PlugInstall +qall"
    echo ""
    echo "3. Powerlevel10k 配置："
    echo "   p10k configure"
    echo ""
    echo "4. 检查 SSH 密钥："
    echo "   确保 ~/.ssh/id_rsa 存在"
    echo "==========================================="
}

# 卸载函数（可选）
uninstall_dotfiles() {
    log_warning "开始卸载 dotfiles..."
    
    # 删除符号链接
    rm -f "$HOME/.profile"
    rm -f "$HOME/.zshrc"
    rm -f "$HOME/.p10k.zsh"
    rm -f "$HOME/.config/nvim/init.vim"
    rm -f "$HOME/.ssh/config"
    rm -f "$HOME/.gitconfig"
    
    log_success "dotfiles 已卸载"
    log_info "原始文件备份在 *.backup.* 文件中"
}

# 显示帮助
show_help() {
    echo "用法: $0 [选项]"
    echo ""
    echo "选项:"
    echo "  install     安装 dotfiles（默认）"
    echo "  uninstall   卸载 dotfiles"
    echo "  help        显示此帮助信息"
    echo ""
    echo "示例:"
    echo "  $0 install     # 安装配置"
    echo "  $0 uninstall   # 卸载配置"
}

# 主程序
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
            log_error "未知操作: $action"
            show_help
            exit 1
            ;;
    esac
}

# 运行主程序
main "$@"

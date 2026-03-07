# 🚀 乐豆芽的 Dotfiles

个人配置文件集合，用于快速设置开发环境。

## 📁 目录结构

```
dotfiles/
├── README.md          # 说明文件
├── install.sh         # 安装脚本
├── .profile           # Shell 环境配置
├── zsh/               # Zsh 配置
│   ├── .zshrc         # 主配置文件
│   ├── .p10k.zsh      # Powerlevel10k 主题配置
│   └── .zshrc.pre-oh-my-zsh # Oh My Zsh 原始配置
├── nvim/              # Neovim 配置
│   └── init.vim       # Neovim 配置文件
├── ssh/               # SSH 配置
│   └── config         # SSH 主机配置
├── git/               # Git 配置
│   └── .gitconfig     # Git 全局配置
├── bin/               # 自定义脚本
└── scripts/           # 工具脚本
```

## 🚀 快速安装

### 方法1：使用安装脚本
```bash
# 克隆仓库
git clone https://github.com/你的用户名/dotfiles.git ~/dotfiles
cd ~/dotfiles

# 运行安装脚本
chmod +x install.sh
./install.sh
```

### 方法2：手动安装
```bash
# 创建符号链接
ln -sf ~/dotfiles/.profile ~/.profile
ln -sf ~/dotfiles/zsh/.zshrc ~/.zshrc
ln -sf ~/dotfiles/zsh/.p10k.zsh ~/.p10k.zsh
mkdir -p ~/.config/nvim
ln -sf ~/dotfiles/nvim/init.vim ~/.config/nvim/init.vim
mkdir -p ~/.ssh
ln -sf ~/dotfiles/ssh/config ~/.ssh/config
ln -sf ~/dotfiles/git/.gitconfig ~/.gitconfig
```

## 🔧 包含的配置

### Zsh
- Oh My Zsh 框架
- Powerlevel10k 主题
- Git 插件
- NVM (Node Version Manager)
- OpenClaw 自动补全
- 自定义别名和函数

### Neovim
- 基础编辑器设置
- 插件管理 (vim-plug)
- 语法高亮 (Treesitter)
- LSP 支持 (clangd)
- 文件树 (NERDTree)
- 状态栏 (vim-airline)

### SSH
- 学校服务器配置 (asc-server, hpc1, hpc2)
- GitHub SSH 配置

### Git
- 凭据存储配置

## ⚙️ 安装依赖

### 基础依赖
```bash
# Ubuntu/Debian
sudo apt update
sudo apt install -y zsh git curl wget neovim

# 安装 Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# 安装 Powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# 安装 vim-plug (Neovim)
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
```

### 可选依赖
```bash
# 安装 NVM (Node.js)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

# 安装 clangd (C/C++ LSP)
sudo apt install -y clangd-15
sudo update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-15 100
```

## 🛠️ 自定义脚本

### `bin/` 目录
存放个人常用脚本，安装时会自动添加到 PATH。

### `scripts/` 目录
存放环境设置和工具脚本。

## 🔄 更新配置

1. 修改 dotfiles 中的配置文件
2. 提交更改到 Git
3. 在新环境中重新运行安装脚本

## 📝 注意事项

1. **SSH 密钥**：不包含私钥文件，需要手动复制 `~/.ssh/id_rsa`
2. **Neovim 插件**：首次运行需要执行 `:PlugInstall`
3. **Powerlevel10k**：首次运行需要执行 `p10k configure`
4. **环境变量**：检查 `.profile` 中的路径设置

## 🤝 贡献

欢迎提交 Issue 和 Pull Request 来改进配置。

## 📄 许可证

MIT License

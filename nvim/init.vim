" ==========================================
" 1. 基础设置 (Basic Settings)
" ==========================================
" 编码设置 (防止中文乱码)
set fileencodings=utf-8,gbk,utf-16,cp936
set encoding=utf-8

" 界面设置
set number              " 显示行号
set ruler               " 显示标尺
set laststatus=2        " 总是显示状态栏
set cursorline          " 高亮当前行
set splitright          " 新窗口在右侧打开
set shortmess+=I        "以此处省略启动画面

" 行为设置
set hidden              " 允许隐藏未保存的 Buffer (切换文件必备)
set ignorecase          " 搜索忽略大小写
set smartcase           " 智能大小写 (输入大写时才敏感)
set incsearch           " 增量搜索 (边输边高亮)
set mouse=a             " 启用鼠标
set clipboard=unnamedplus " 与系统剪贴板互通

" 缩进设置 (C语言标准 4空格)
set tabstop=4
set shiftwidth=4
set expandtab           " Tab 转空格
set autoindent

" ==========================================
" 2. 插件管理 (Plugins)
" ==========================================
call plug#begin('~/.vim/plugged')

" --- 界面与辅助 ---
Plug 'vim-airline/vim-airline'          " 底部彩条
Plug 'vim-airline/vim-airline-themes'   " 彩条主题
Plug 'jiangmiao/auto-pairs'             " 括号自动补全 () [] {}
Plug 'preservim/nerdtree'               " 左侧文件树

" --- Neovim 核心能力 ---
if has('nvim')
    " 语法高亮引擎 (Treesitter)
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    
    " LSP 代码智能感知 (Clangd)
    " !!! 锁定 v0.1.7 版本，完美兼容 Neovim 0.10.x，无报错 !!!
    Plug 'neovim/nvim-lspconfig', { 'tag': 'v0.1.7' }
endif

call plug#end()

" ==========================================
" 3. 快捷键映射 (Key Mappings)
" ==========================================
let mapleader=" "       " 设置空格键为 Leader 键

" [通用]
nmap Q <Nop>            " 禁用 Ex 模式
nnoremap <C-s> :w<CR>   " Ctrl+s 保存
nnoremap <leader>q :q<CR> " 空格+q 退出

" [文件树 NERDTree]
map <C-n> :NERDTreeToggle<CR> " Ctrl+n 开关文件树

" [Buffer 切换]
nnoremap <Tab> :bnext<CR>     " Tab 切换下一个文件
nnoremap <S-Tab> :bprev<CR>   " Shift+Tab 切换上一个

" [LSP 智能跳转 - C语言开发核心]
" gd: 跳转到定义 (Go to Definition)
nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
" gD: 跳转到声明
nnoremap <silent> gD <cmd>lua vim.lsp.buf.declaration()<CR>
" K:  查看文档/悬浮提示
nnoremap <silent> K <cmd>lua vim.lsp.buf.hover()<CR>
" <leader>rn: 重命名变量 (Rename)
nnoremap <silent> <leader>rn <cmd>lua vim.lsp.buf.rename()<CR>

" ==========================================
" 4. Lua 配置 (Treesitter & LSP)
" ==========================================
" Airline 设置
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

if has('nvim')
lua << EOF
  -- 1. Treesitter (高亮)
  -- 使用 pcall 防止插件未安装时报错崩溃
  local status_ts, ts_configs = pcall(require, "nvim-treesitter.configs")
  if status_ts then
    ts_configs.setup {
      ensure_installed = { "c", "cpp", "python", "bash", "lua" },
      highlight = { enable = true, additional_vim_regex_highlighting = false },
      indent = { enable = true }
    }
  end

  -- 2. LSP (代码补全)
  local status_lsp, lspconfig = pcall(require, "lspconfig")
  if status_lsp then
    -- 启动 C/C++ 服务 (clangd)
    lspconfig.clangd.setup{}
  end
EOF
endif

# System-Weaver：完整开发环境搭建指南

一套全面、自动化的脚本，将你的 Ubuntu/Debian 系统打造成现代化、强大的开发环境，集成 Zsh、Tmux、Neovim（AstroNvim 配置）及各类必备开发工具。

## 🚀 快速开始

```bash
git clone https://github.com/your-username/System-Weaver.git
cd System-Weaver
chmod +x server.sh
./server.sh
```

## 📦 完整功能列表

### 🖥️ 终端环境
- **Zsh**：现代化 Shell，功能强大
- **Zinit**：快速轻量的插件管理器（替代 Oh-My-Zsh）
- **Starship**：跨平台、可定制的提示符，集成 Git 信息
- **FiraCode Nerd Font**：带连字和图标的编程字体

### 🔧 开发工具
- **Neovim v0.11+**：通过 AppImage 安装最新版（绕过 apt 旧包）
- **AstroNvim**：功能丰富的 Neovim 配置，支持 LSP、调试和现代 UI
- **Tmux**：终端复用器，带自定义配置和插件管理
- **Git**：版本控制，配合增强工具

### 🌐 语言管理器
- **NVM**：Node.js 版本管理器，适用于 JavaScript/TypeScript 开发
- **Rustup**：Rust 工具链安装与版本管理
- **uv**：超快 Python 包管理器（Rust 编写）

### 🛠️ 系统工具
- **ripgrep (rg)**：超快文本搜索工具
- **lazygit**：终端 Git 操作界面
- **Tree-sitter CLI**：语法高亮与代码解析
- **gdu**：快速磁盘使用分析器
- **bottom (btm)**：系统资源监控器
- **colorls**：增强版 `ls` 命令，带颜色和图标

### 🎨 视觉增强
- **图标**：通过 Nerd Fonts 提供全面图标支持
- **语法高亮**：终端和编辑器中的高级语法高亮
- **主题**：Starship Pastel Powerline 主题

## ⌨️ 快捷键与命令

### Tmux 快捷键
**前缀键**：`Ctrl+a`（替代默认 `Ctrl+b`）

#### 窗口与面板管理
- `前缀 + |` - 水平分割窗口
- `前缀 + -` - 垂直分割窗口
- `前缀 + h/j/k/l` - 面板间切换（Vim 风格）
- `前缀 + H/J/K/L` - 调整面板大小
- `前缀 + r` - 重新加载 Tmux 配置

#### 插件管理
- `前缀 + I` - 安装 Tmux 插件（TPM）
- `前缀 + U` - 更新插件
- `前缀 + Alt+u` - 卸载插件

### AstroNvim/Neovim 快捷键
**主键（Leader）**：`<Space>`（AstroNvim 默认）

#### 文件操作
- `<Leader>ff` - 查找文件（模糊查找）
- `<Leader>fw` - 文件内查找单词（实时 grep）
- `<Leader>fb` - 查找缓冲区
- `<Leader>fh` - 查找帮助标签
- `<Leader>fo` - 查找历史文件

#### LSP（语言服务器协议）
- `gd` - 跳转到定义
- `gr` - 跳转到引用
- `K` - 显示悬浮信息
- `<Leader>ca` - 代码操作
- `<Leader>rn` - 重命名符号
- `]d` / `[d` - 下/上一个诊断

#### 插件管理
- `<Leader>pS` - 同步插件（Lazy.nvim）
- `<Leader>pU` - 更新插件
- `<Leader>pu` - 检查更新
- `<Leader>pa` - AstroUpdate（更新插件和 Mason 包）

#### 终端集成
- `<Leader>tf` - 切换浮动终端
- `<Leader>th` - 切换水平终端
- `<Leader>tv` - 切换垂直终端
- `<Leader>tl` - 切换 lazygit
- `<Leader>tn` - 切换 Node REPL
- `<Leader>tp` - 切换 Python REPL
- `<Leader>tt` - 切换 bottom（系统监控）
- `<Leader>tu` - 切换 gdu（磁盘使用）

### Zsh 快捷键与别名
#### 自定义别名
- `ls` → `eza --icons` - 增强版 ls，带图标
- `ll` → `eza -l --icons` - 长格式，带图标
- `la` → `eza -la --icons` - 显示全部文件，带图标
- `tree` → `eza --tree --icons` - 树状视图，带图标

#### Zinit 插件特性
- **自动建议**：输入时根据历史给出建议
- **语法高亮**：实时命令语法高亮
- **目录跳转**：用 `z <部分目录名>` 快速跳转常用目录

## 💡 使用示例

### 开发环境搭建

#### Python 开发
```bash
# 安装 Python 版本并创建虚拟环境
uv venv -p 3.11 my-project
source my-project/bin/activate
uv pip install numpy pandas fastapi

# 在 Neovim 中
:LspInstall pyright
:TSInstall python
:DapInstall python
```

#### Node.js 开发
```bash
# 安装并使用 Node.js LTS 版本
nvm install --lts
nvm use --lts

# 在 Neovim 中
:LspInstall ts_ls
:TSInstall javascript typescript
:DapInstall node2
```

#### Rust 开发
```bash
# Rust 已通过 rustup 安装
cargo new my-project
cd my-project

# 在 Neovim 中
:LspInstall rust_analyzer
:TSInstall rust
:DapInstall codelldb
```

### 在 Neovim 中使用 LSP 功能

#### 安装语言服务器
```vim
:LspInstall pyright          " Python
:LspInstall ts_ls            " TypeScript/JavaScript
:LspInstall rust_analyzer    " Rust
:LspInstall gopls            " Go
:LspInstall clangd           " C/C++
:LspInstall lua_ls           " Lua
```

#### 安装语法解析器
```vim
:TSInstall python javascript typescript rust go c cpp lua
:TSInstall html css json yaml toml markdown
```

#### 安装调试器
```vim
:DapInstall python           " Python 调试器
:DapInstall node2            " Node.js 调试器
:DapInstall codelldb         " Rust/C++ 调试器
```

### 使用 lazygit 进行 Git 工作流
```bash
# 在终端中打开 lazygit
lazygit

# 或在 Neovim 内
<Leader>tl
```

**lazygit 快捷键：**
- `j/k` - 上下移动
- `<Space>` - 暂存/取消暂存文件
- `c` - 提交
- `P` - 推送
- `p` - 拉取
- `q` - 退出

### 使用 ripgrep 搜索文件
```bash
# 在文件中搜索文本
rg "function" --type py        # 在 Python 文件中搜索
rg "TODO" -A 3 -B 3           # 显示前后 3 行
rg "pattern" --hidden         # 包含隐藏文件
```

### 系统监控
```bash
# 磁盘使用分析
gdu

# 系统资源监控
btm
# 或
bottom
```

## 🔧 配置细节

### 自定义 AstroNvim

#### 添加自定义插件
编辑 `~/.config/nvim/lua/plugins/user.lua`：
```lua
return {
  {
    "your-plugin/name",
    config = function()
      -- 插件配置
    end,
  },
}
```

#### 自定义按键映射
编辑 `~/.config/nvim/lua/plugins/astrocore.lua`：
```lua
return {
  "AstroNvim/astrocore",
  opts = {
    mappings = {
      n = {
        ["<Leader>custom"] = { "<cmd>YourCommand<cr>", desc = "自定义命令" },
      },
    },
  },
}
```

### 通过 Zinit 添加 Zsh 插件

编辑 `~/.zshrc` 并在 Zinit 部分添加：
```bash
# 添加新插件
zinit light "author/plugin-name"

# 按条件加载插件
zinit ice wait"1" lucid
zinit light "author/another-plugin"
```

### 修改 Tmux 设置

编辑 `~/.tmux.conf`：
```bash
# 添加自定义快捷键
bind-key C-h select-window -t :-
bind-key C-l select-window -t :+

# 重新加载配置
tmux source-file ~/.tmux.conf
```

### 更换 Starship 主题

```bash
# 列出可用预设
starship preset --list

# 应用不同预设
starship preset nerd-font-symbols -o ~/.config/starship.toml
```

## 🔄 维护命令

### 更新环境
```bash
# 更新所有包管理器
sudo apt update && sudo apt upgrade

# 更新 Rust
rustup update

# 更新 Node.js 到最新 LTS
nvm install --lts --reinstall-packages-from=current

# 更新 Python 包
uv pip list --outdated
```

### Neovim 维护
```vim
:AstroUpdate                 " 更新 AstroNvim 和 Mason 包
:Lazy update                 " 更新插件
:Mason                       " 管理 LSP、格式化器、linter
:checkhealth                 " 检查 Neovim 健康状况
```

### Tmux 插件管理
```bash
# 在 Tmux 会话中
Prefix + I                   # 安装新插件
Prefix + U                   # 更新插件
Prefix + Alt+u               # 移除未用插件
```

## 🚨 故障排查

### 常见问题

#### Neovim 版本问题
如果 AstroNvim 报告 Neovim 版本过低：
```bash
# 检查当前版本
nvim --version

# 重新安装最新版
rm ~/.local/bin/nvim*
./server.sh  # 重新运行脚本
```

#### 字体显示问题
- 请确保你的终端使用 Nerd Font 字体
- 推荐字体：FiraCode Nerd Font、JetBrains Mono Nerd Font
- 在终端设置中配置字体，而不是在服务器端

#### 插件安装失败
```vim
" 在 Neovim 中检查插件状态
:Lazy
:Mason
:checkhealth
```

#### Tmux 插件问题
```bash
# 重新安装 TPM
rm -rf ~/.tmux/plugins/tpm
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# 然后：Prefix + I
```

## 📁 文件结构

```
~/.config/
├── nvim/                    # AstroNvim 配置
│   ├── lua/
│   │   ├── plugins/         # 插件配置
│   │   └── community.lua    # AstroCommunity 导入
│   └── init.lua
├── starship.toml           # Starship 提示符配置
~/.local/
├── bin/
│   └── nvim                # Neovim AppImage 软链接
└── share/
    ├── fonts/              # Nerd Fonts 字体
    └── zinit/              # Zinit 安装目录
~/.tmux/
└── plugins/                # Tmux 插件
~/.zshrc                    # Zsh 配置
~/.tmux.conf               # Tmux 配置
```

## 🎯 后续步骤

安装完成后：

1. **重启终端会话** 以激活 Zsh
2. **在终端设置中配置 Nerd Font 字体**
3. **启动 Tmux 并安装插件**：`tmux` → `Prefix + I`
4. **启动 Neovim 并等待 AstroNvim 自动安装**：`nvim`
5. **根据开发需求安装语言服务器**
6. **探索快捷键并根据个人习惯自定义**

享受你的强大现代开发环境！🚀

## 📚 进阶配置示例

### AstroNvim 语言包配置

#### Python 开发包
```lua
-- 在 ~/.config/nvim/lua/community.lua 中
return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.pack.python" },
  { import = "astrocommunity.pack.docker" },
  { import = "astrocommunity.pack.json" },
  { import = "astrocommunity.pack.yaml" },
}
```

#### Web 开发包
```lua
-- 在 ~/.config/nvim/lua/community.lua 中
return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.pack.typescript" },
  { import = "astrocommunity.pack.html-css" },
  { import = "astrocommunity.pack.tailwindcss" },
  { import = "astrocommunity.pack.vue" },
  { import = "astrocommunity.pack.react" },
}
```

### 自定义 Zsh 函数

添加到 `~/.zshrc`：
```bash
# 快速创建项目
mkproject() {
    mkdir -p "$1" && cd "$1"
    git init
    echo "# $1" > README.md
    echo "node_modules/\n.env\n*.log" > .gitignore
}

# 用 fzf 快速跳转目录
fcd() {
    local dir
    dir=$(find ${1:-.} -type d 2> /dev/null | fzf +m) && cd "$dir"
}

# Git 快捷命令
alias gst="git status"
alias gco="git checkout"
alias gcb="git checkout -b"
alias gp="git push"
alias gl="git pull"
alias ga="git add"
alias gc="git commit"
```

### Tmux 高级配置

添加到 `~/.tmux.conf`：
```bash
# 会话管理
bind-key S command-prompt -p "新会话名:" "new-session -A -s '%%'"
bind-key K confirm kill-session

# 窗口管理
bind-key -n M-h previous-window
bind-key -n M-l next-window
bind-key -n M-1 select-window -t 1
bind-key -n M-2 select-window -t 2
bind-key -n M-3 select-window -t 3

# 复制模式增强
bind-key -T copy-mode-vi v send-keys -X begin-selection
bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "xclip -in -selection clipboard"
```

## 🔍 详细命令参考

### Neovim LSP 命令
```vim
" 语言服务器管理
:LspInfo                     " 显示 LSP 客户端信息
:LspStart <server>           " 启动指定 LSP 服务器
:LspStop <server>            " 停止指定 LSP 服务器
:LspRestart                  " 重启 LSP 服务器

" 诊断相关
:lua vim.diagnostic.open_float()  " 浮窗显示诊断信息
:lua vim.diagnostic.setloclist()  " 添加诊断到位置列表

" 代码导航
:lua vim.lsp.buf.declaration()    " 跳转到声明
:lua vim.lsp.buf.definition()     " 跳转到定义
:lua vim.lsp.buf.implementation() " 跳转到实现
:lua vim.lsp.buf.type_definition() " 跳转到类型定义

" 代码操作
:lua vim.lsp.buf.code_action()    " 显示代码操作
:lua vim.lsp.buf.format()         " 格式化当前缓冲区
:lua vim.lsp.buf.rename()         " 重命名符号
```

### Mason 包管理
```vim
:Mason                       " 打开 Mason UI
:MasonInstall <package>      " 安装包
:MasonUninstall <package>    " 卸载包
:MasonUpdate                 " 更新所有包
:MasonLog                    " 显示安装日志
```

### Tree-sitter 命令
```vim
:TSInstall <language>        " 安装解析器
:TSUninstall <language>      " 卸载解析器
:TSUpdate                    " 更新所有解析器
:TSBufEnable highlight       " 启用高亮
:TSBufDisable highlight      " 禁用高亮
:InspectTree                 " 显示语法树
```

### 调试（DAP）命令
```vim
:DapInstall <debugger>       " 安装调试器
:DapUninstall <debugger>     " 卸载调试器
:DapContinue                 " 启动/继续调试
:DapToggleBreakpoint         " 切换断点
:DapStepOver                 " 单步跳过
:DapStepInto                 " 单步进入
:DapStepOut                  " 单步跳出
:DapTerminate                " 终止调试会话
```

## 🛡️ 安全与最佳实践

### 环境安全
```bash
# 检查已安装包
dpkg -l | grep -E "(zsh|tmux|neovim)"

# 校验关键下载文件的校验和
sha256sum ~/.local/bin/nvim.appimage

# 定期安全更新
sudo apt update && sudo apt upgrade
sudo apt autoremove
```

### Git 安全配置
```bash
# 配置 Git 身份信息
git config --global user.name "你的名字"
git config --global user.email "your.email@example.com"

# 启用 Git 凭证助手
git config --global credential.helper store

# 配置 GitHub SSH 密钥
ssh-keygen -t ed25519 -C "your.email@example.com"
```

### 备份重要配置
```bash
# 创建备份脚本
#!/bin/bash
BACKUP_DIR="$HOME/dotfiles-backup-$(date +%Y%m%d)"
mkdir -p "$BACKUP_DIR"

cp ~/.zshrc "$BACKUP_DIR/"
cp ~/.tmux.conf "$BACKUP_DIR/"
cp -r ~/.config/nvim "$BACKUP_DIR/"
cp ~/.config/starship.toml "$BACKUP_DIR/"

echo "备份已创建于 $BACKUP_DIR"
```

## 🔧 性能优化

### Zsh 性能优化
```bash
# 添加到 ~/.zshrc 以加快启动
# NVM 懒加载
lazy_load_nvm() {
    unset -f node npm npx nvm
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
}

node() { lazy_load_nvm; node "$@"; }
npm() { lazy_load_nvm; npm "$@"; }
npx() { lazy_load_nvm; npx "$@"; }
nvm() { lazy_load_nvm; nvm "$@"; }
```

### Neovim 性能优化
```lua
-- 添加到 ~/.config/nvim/lua/plugins/performance.lua
return {
  {
    "AstroNvim/astrocore",
    opts = {
      options = {
        opt = {
          -- 提升性能
          updatetime = 250,
          timeoutlen = 300,
          -- 降低内存占用
          maxmempattern = 2000,
          -- 更快补全
          completeopt = { "menu", "menuone", "noselect" },
        },
      },
    },
  },
}
```

### 系统资源监控
```bash
# 监控系统资源
htop                         # 交互式进程查看器
iotop                        # I/O 监控
nethogs                      # 按进程显示网络流量

# 磁盘空间管理
ncdu                         # NCurses 磁盘使用
 df -h                        # 磁盘空间用量
du -sh ~/.config/nvim        # Neovim 配置大小
```

## 📖 学习资源

### Neovim & AstroNvim
- [AstroNvim 官方文档](https://docs.astronvim.com/)
- [Neovim 用户手册](https://neovim.io/doc/user/)
- [Learn Vimscript the Hard Way](https://learnvimscriptthehardway.stevelosh.com/)
- [Lua in Neovim](https://github.com/nanotee/nvim-lua-guide)

### Tmux
- [Tmux 速查表](https://tmuxcheatsheet.com/)
- [The Tao of tmux](https://leanpub.com/the-tao-of-tmux)

### Zsh & Shell 脚本
- [Zsh 手册](https://zsh.sourceforge.io/Doc/)
- [高级 Bash 脚本指南](https://tldp.org/LDP/abs/html/)

### Git & 开发流程
- [Pro Git 书籍](https://git-scm.com/book)
- [GitHub Flow](https://guides.github.com/introduction/flow/)
- [Conventional Commits](https://www.conventionalcommits.org/)

## 🤝 贡献指南

### 问题反馈
1. 请先检查已有 issue
2. 提供系统信息：`uname -a`、`lsb_release -a`
3. 包含错误信息和日志
4. 描述复现步骤

### 提交改进
1. Fork 本仓库
2. 创建功能分支：`git checkout -b feature/amazing-feature`
3. 充分测试你的更改
4. 使用描述性提交信息
5. 提交 Pull Request

### 开发环境搭建
```bash
# 克隆用于开发
git clone https://github.com/your-username/System-Weaver.git
cd System-Weaver

# 在容器中测试
docker run -it ubuntu:22.04 bash
# 然后运行你的修改脚本
```

---

**祝你在超强开发环境中愉快编码！** 🎉✨

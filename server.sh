#!/bin/bash
# ==============================================================================
#                 现代化 Zsh & Tmux & Neovim 终端环境优化配置脚本
#
# 脚本特性:
# 1. 模块化设计: 所有功能封装在函数中，清晰易维护。
# 2. 断点续传: 自动跳过已成功执行的步骤，可从失败处继续。
# 3. 轻量高效: 移除 Oh-My-Zsh，直接使用 Zinit 管理插件。
# 4. Python 工具链: 使用新兴的高性能包管理器 uv。
# 5. 现代化编辑器: 安装最新版 Neovim 和 AstroNvim 配置。
# 6. 自动化配置:
#    - 安装核心依赖与工具 (Zsh, Tmux, Git, Starship, colorls, uv 等)。
#    - 安装 FiraCode Nerd Font 字体。
#    - 安装 Neovim (AppImage) 和 AstroNvim 配置。
#    - 安装 AstroNvim 依赖工具 (ripgrep, lazygit, tree-sitter 等)。
#    - 自动生成 .zshrc, .tmux.conf, 和 starship.toml 配置文件。
#    - 设置 Zsh 为默认 Shell。
#
# @version: 5.0 (Neovim + AstroNvim Edition)
# ==============================================================================

# --- 安全设置 ---
# 如果任何命令失败，立即退出脚本
set -e
# 如果管道中的任何命令失败，则整个管道的返回码为非零
set -o pipefail

# --- 状态与常量定义 ---
STATE_DIR="$HOME/.config_setup_state"

# --- 助手函数 ---
print_info() {
    echo -e "\n\e[1;34m[INFO]\e[0m $1"
}

print_success() {
    echo -e "\e[1;32m[SUCCESS]\e[0m $1"
}

print_warning() {
    echo -e "\e[1;33m[WARNING]\e[0m $1"
}

print_error() {
    echo -e "\e[1;31m[ERROR]\e[0m $1" >&2
    exit 1
}

# --- 核心逻辑：步骤执行与状态检查 ---
# 用法: run_step "步骤名" "要执行的函数名"
run_step() {
    local step_name="$1"
    local step_func="$2"
    local state_file="$STATE_DIR/$step_name.done"

    if [ -f "$state_file" ]; then
        print_info "步骤 '$step_name' 已完成，跳过。"
        return 0
    fi

    print_info "===== 开始执行步骤: $step_name ====="
    # 调用对应的函数
    if "$step_func"; then
        print_success "步骤 '$step_name' 执行成功。"
        touch "$state_file"
    else
        print_error "步骤 '$step_name' 执行失败。请检查错误信息并重新运行脚本。"
        # set -e 会在此处自动退出脚本
    fi
}

# --- 模块化功能函数 ---

# 步骤 0: 初始化环境
setup_environment() {
    print_info "初始化环境，创建状态目录..."
    mkdir -p "$STATE_DIR"
    # 确保在用户主目录下执行
    cd "$HOME" || return 1
}

# 步骤 1: 安装系统依赖
install_system_dependencies() {
    print_info "更新软件包列表并安装系统依赖..."
    sudo apt-get update && sudo apt-get install -y \
        build-essential \
        pkg-config \
        libssl-dev \
        zsh \
        tmux \
        git \
        curl \
        wget \
        ruby-full \
        unzip \
        fontconfig || return 1
}

# 步骤 2: 安装 Nerd Font (FiraCode)
install_nerd_font() {
    print_info "安装 FiraCode Nerd Font..."
    local font_dir="$HOME/.local/share/fonts"
    mkdir -p "$font_dir"

    if [ -f "$font_dir/Fira Code Regular Nerd Font Complete.ttf" ]; then
        print_info "FiraCode Nerd Font 已存在。"
        return 0
    fi

    wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/FiraCode.zip -O /tmp/FiraCode.zip
    unzip -o /tmp/FiraCode.zip -d "$font_dir" 'FiraCodeNerdFont-*.ttf'
    rm /tmp/FiraCode.zip
    # 更新字体缓存
    fc-cache -f -v
}

# 步骤 3: 备份现有配置文件
backup_configs() {
    print_info "备份现有配置文件..."
    local backup_dir="$HOME/config_backups_$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$backup_dir"
    
    # 定义需要备份的文件列表
    local configs_to_backup=(".zshrc" ".tmux.conf" ".zinit" ".config/starship.toml" ".tmux")

    for cfg in "${configs_to_backup[@]}"; do
        if [ -e "$HOME/$cfg" ]; then
            print_info "备份 $HOME/$cfg 到 $backup_dir"
            mv "$HOME/$cfg" "$backup_dir/"
        fi
    done
    print_success "备份完成，旧文件已移至 $backup_dir"
}

# 步骤 4: 安装核心工具
install_core_tools() {
    # Zinit (Zsh 插件管理器)
    print_info "安装 Zinit..."
    if [ ! -d "$HOME/.local/share/zinit/zinit.git" ]; then
        mkdir -p "$HOME/.local/share/zinit"
        chmod g-rwX "$HOME/.local/share/zinit"
        git clone https://github.com/zdharma-continuum/zinit.git "$HOME/.local/share/zinit/zinit.git"
    else
        print_info "Zinit 已安装。"
    fi

    # Starship (跨平台提示符)
    print_info "安装 Starship..."
    if ! command -v starship &> /dev/null; then
        curl -sS https://starship.rs/install.sh | sh -s -- -y
    else
        print_info "Starship 已安装。"
    fi

    # colorls
    print_info "安装 colorls..."
    if ! gem spec colorls &> /dev/null; then
        sudo gem install colorls
    else
        print_info "colorls 已安装。"
    fi

    # Tmux Plugin Manager (TPM)
    print_info "安装 Tmux Plugin Manager (TPM)..."
    if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    else
        print_info "TPM 已安装。"
    fi
    
    # uv (Python 包管理器)
    print_info "安装 uv..."
    if ! command -v uv &> /dev/null; then
        curl -LsSf https://astral.sh/uv/install.sh | sh
    else
        print_info "uv 已安装。"
    fi
}

# 步骤 5: 安装 Neovim (使用 AppImage)
install_neovim() {
    print_info "安装 Neovim (最新版本)..."
    local nvim_dir="$HOME/.local/bin"
    local nvim_appimage="$nvim_dir/nvim.appimage"
    local nvim_symlink="$nvim_dir/nvim"

    # 创建本地 bin 目录
    mkdir -p "$nvim_dir"

    # 检查是否已安装且版本符合要求
    if [ -f "$nvim_symlink" ] && "$nvim_symlink" --version | grep -q "NVIM v0\.\(1[0-9]\|[2-9][0-9]\)"; then
        print_info "Neovim 已安装且版本符合要求。"
        return 0
    fi

    # 下载最新的 Neovim AppImage
    print_info "下载 Neovim AppImage..."
    wget -O "$nvim_appimage" https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage || return 1

    # 设置执行权限
    chmod +x "$nvim_appimage"

    # 创建符号链接
    ln -sf "$nvim_appimage" "$nvim_symlink"

    # 确保 ~/.local/bin 在 PATH 中 (通过 .zshrc 配置)
    print_success "Neovim 安装完成。"
}

# 步骤 6: 安装 AstroNvim 依赖工具
install_astronvim_dependencies() {
    print_info "安装 AstroNvim 依赖工具..."

    # 安装 ripgrep (用于文件搜索)
    print_info "安装 ripgrep..."
    if ! command -v rg &> /dev/null; then
        sudo apt-get install -y ripgrep || return 1
    else
        print_info "ripgrep 已安装。"
    fi

    # 安装 Tree-sitter CLI
    print_info "安装 Tree-sitter CLI..."
    if ! command -v tree-sitter &> /dev/null; then
        # 使用 npm 安装 tree-sitter-cli (需要先确保 Node.js 可用)
        if command -v npm &> /dev/null; then
            sudo npm install -g tree-sitter-cli
        else
            print_warning "Node.js 未安装，跳过 Tree-sitter CLI 安装。可在安装 Node.js 后手动安装。"
        fi
    else
        print_info "Tree-sitter CLI 已安装。"
    fi

    # 安装 lazygit (Git UI)
    print_info "安装 lazygit..."
    if ! command -v lazygit &> /dev/null; then
        local lazygit_version=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
        curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${lazygit_version}_Linux_x86_64.tar.gz"
        tar xf lazygit.tar.gz lazygit
        sudo install lazygit /usr/local/bin
        rm lazygit lazygit.tar.gz
    else
        print_info "lazygit 已安装。"
    fi

    # 安装 gdu (磁盘使用分析器)
    print_info "安装 gdu..."
    if ! command -v gdu &> /dev/null; then
        sudo apt-get install -y gdu || print_warning "gdu 安装失败，可能在某些 Ubuntu 版本中不可用。"
    else
        print_info "gdu 已安装。"
    fi

    # 安装 bottom (进程查看器)
    print_info "安装 bottom..."
    if ! command -v btm &> /dev/null; then
        sudo apt-get install -y bottom || print_warning "bottom 安装失败，可能在某些 Ubuntu 版本中不可用。"
    else
        print_info "bottom 已安装。"
    fi
}

# 步骤 7: 安装 AstroNvim
install_astronvim() {
    print_info "安装 AstroNvim..."

    # 备份现有的 Neovim 配置
    if [ -d "$HOME/.config/nvim" ]; then
        print_info "备份现有的 Neovim 配置..."
        local backup_dir="$HOME/.config/nvim.bak.$(date +%Y%m%d_%H%M%S)"
        mv "$HOME/.config/nvim" "$backup_dir"
        print_info "现有配置已备份到: $backup_dir"
    fi

    # 清理 Neovim 相关目录 (可选但推荐)
    print_info "清理 Neovim 数据目录..."
    [ -d "$HOME/.local/share/nvim" ] && mv "$HOME/.local/share/nvim" "$HOME/.local/share/nvim.bak.$(date +%Y%m%d_%H%M%S)"
    [ -d "$HOME/.local/state/nvim" ] && mv "$HOME/.local/state/nvim" "$HOME/.local/state/nvim.bak.$(date +%Y%m%d_%H%M%S)"
    [ -d "$HOME/.cache/nvim" ] && mv "$HOME/.cache/nvim" "$HOME/.cache/nvim.bak.$(date +%Y%m%d_%H%M%S)"

    # 克隆 AstroNvim 模板
    print_info "克隆 AstroNvim 模板..."
    git clone --depth 1 https://github.com/AstroNvim/template ~/.config/nvim || return 1

    # 移除模板的 git 连接
    rm -rf ~/.config/nvim/.git

    print_success "AstroNvim 安装完成！"
}

# 步骤 8: 安装语言环境管理器
install_language_managers() {
    # Rustup
    print_info "安装 Rust..."
    if [ ! -d "$HOME/.cargo" ]; then
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    else
        print_info "Rust 已安装。"
    fi

    # NVM (Node Version Manager)
    print_info "安装 NVM..."
    if [ ! -d "$HOME/.nvm" ]; then
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    else
        print_info "NVM 已安装。"
    fi
}

# 步骤 9.1: 生成 .zshrc 配置文件
configure_zsh() {
    print_info "创建 .zshrc 配置文件..."
    # shellcheck source=/dev/null
    cat > "$HOME/.zshrc" << 'EOF'
# ~/.zshrc (Optimized, without Oh-My-Zsh)

### PATH Configuration
# 添加本地 bin 目录到 PATH (用于 Neovim 等工具)
export PATH="$HOME/.local/bin:$PATH"

### Zinit 插件管理器
# 加载 Zinit
if [[ -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
  source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
  autoload -Uz _zinit
  (( ${+_comps} )) && _comps[zinit]=_zinit

  # 加载 Zinit 核心扩展
  zinit light-mode for \
      zdharma-continuum/zinit-annex-as-monitor \
      zdharma-continuum/zinit-annex-bin-gem-node \
      zdharma-continuum/zinit-annex-patch-dl \
      zdharma-continuum/zinit-annex-rust

  # --- 插件列表 ---
  # 语法高亮 (必须在自动建议之前加载)
  zinit ice compile'(./fast-syntax-highlighting.plugin.zsh)' atload'# unfunction to prevent clash'
  zinit light "zdharma-continuum/fast-syntax-highlighting"

  # 自动建议
  zinit light "zsh-users/zsh-autosuggestions"

  # 目录快速跳转
  zinit light "agkozak/zsh-z"
fi
### End of Zinit chunk

### Aliases
alias ls='eza --icons'
alias ll='eza -l --icons'
alias la='eza -la --icons'
alias tree='eza --tree --icons'

appimage2desktop() {
    # 检查参数
    if [ $# -lt 1 ]; then
        echo "用法: appimage2desktop <AppImage文件路径> [图标路径] [-n|--no-sandbox]"
        return 1
    fi
    
    # 默认不使用 --no-sandbox
    USE_NO_SANDBOX=false
    
    # 处理参数
    APPIMAGE_PATH=""
    ICON_PATH=""
    
    # 解析参数
    while [ $# -gt 0 ]; do
        case "$1" in
            -n|--no-sandbox)
                USE_NO_SANDBOX=true
                shift
                ;;
            *)
                if [ -z "$APPIMAGE_PATH" ]; then
                    APPIMAGE_PATH=$(realpath "$1")
                elif [ -z "$ICON_PATH" ] && [ -f "$1" ]; then
                    ICON_PATH=$(realpath "$1")
                fi
                shift
                ;;
        esac
    done
    
    # 检查是否提供了AppImage路径
    if [ -z "$APPIMAGE_PATH" ]; then
        echo "错误: 未提供AppImage文件路径"
        return 1
    fi
    
    # 检查文件是否存在
    if [ ! -f "$APPIMAGE_PATH" ]; then
        echo "错误: 文件 '$APPIMAGE_PATH' 不存在"
        return 1
    fi
    
    # 检查是否是AppImage文件
    if [[ ! "$APPIMAGE_PATH" =~ \.AppImage$ ]]; then
        echo "警告: 文件 '$1' 可能不是AppImage文件，但仍将继续"
    fi
    
    # 确保文件可执行
    chmod +x "$APPIMAGE_PATH"
    
    # 获取应用名称（去掉路径和扩展名）
    APP_NAME=$(basename "$APPIMAGE_PATH" .AppImage)
    
    # 询问用户应用名称
    echo -n "应用名称 [$APP_NAME]: "
    read USER_APP_NAME
    if [ -n "$USER_APP_NAME" ]; then
        APP_NAME="$USER_APP_NAME"
    fi
    
    # 如果没有设置图标路径
    if [ -z "$ICON_PATH" ]; then
        echo "未提供有效的图标路径，将使用默认图标"
    fi
    
    # 创建应用目录（如果不存在）
    mkdir -p ~/.local/share/applications
    
    # 创建desktop文件
    DESKTOP_FILE="$HOME/.local/share/applications/${APP_NAME}.desktop"
    
    echo "[Desktop Entry]" > "$DESKTOP_FILE"
    echo "Version=1.0" >> "$DESKTOP_FILE"
    echo "Type=Application" >> "$DESKTOP_FILE"
    echo "Name=$APP_NAME" >> "$DESKTOP_FILE"
    echo "Comment=$APP_NAME" >> "$DESKTOP_FILE"
    # 根据是否使用 --no-sandbox 添加不同的执行命令
    if [ "$USE_NO_SANDBOX" = true ]; then
        echo "Exec=\"$APPIMAGE_PATH\" --no-sandbox" >> "$DESKTOP_FILE"
        echo "添加了 --no-sandbox 参数到启动命令"
    else
        echo "Exec=\"$APPIMAGE_PATH\"" >> "$DESKTOP_FILE"
    fi
    echo "Terminal=false" >> "$DESKTOP_FILE"
    echo "Categories=Utility;" >> "$DESKTOP_FILE"
    
    # 如果有图标则添加
    if [ -n "$ICON_PATH" ]; then
        echo "Icon=$ICON_PATH" >> "$DESKTOP_FILE"
    fi
    
    # 设置权限
    chmod +x "$DESKTOP_FILE"
    
    echo "桌面快捷方式已创建: $DESKTOP_FILE"
    
    # 更新桌面数据库
    update-desktop-database ~/.local/share/applications 2>/dev/null || true
    
    return 0
}
alias a2d=appimage2desktop


### Language Environment Managers

# NVM (Node.js)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Rust
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

# uv (Python) - 安装程序会自动添加到 PATH，无需额外配置

### Shell Tools Initialization

# colorls tab completion
if command -v gem &> /dev/null && gem spec colorls &> /dev/null; then
    source "$(dirname "$(gem which colorls)")/tab_complete.sh"
fi

# Starship Prompt
eval "$(starship init zsh)"

EOF
}

# 步骤 9.2: 生成 starship.toml 配置文件
configure_starship() {
    print_info "使用 preset 'pastel-powerline' 创建 starship.toml..."
    mkdir -p "$HOME/.config"
    # 使用 preset 命令生成配置
    starship preset pastel-powerline -o "$HOME/.config/starship.toml"
}

# 步骤 9.3: 生成 .tmux.conf 配置文件
configure_tmux() {
    print_info "创建 .tmux.conf 配置文件..."
    cat > "$HOME/.tmux.conf" << 'EOF'
# ==============================================================================
#                            ~/.tmux.conf 配置文件
# ==============================================================================

# ---------------------------
# 基本设置
# ---------------------------
# 设置前缀键为 Ctrl-a
unbind C-b
set-option -g prefix C-a
bind-key C-a send-prefix

# 降低命令延迟
set -sg escape-time 1

# 设置终端颜色 (重要：确保与 shell 兼容)
set -g default-terminal "screen-256color"
set-option -ga terminal-overrides ",xterm-256color:Tc"

# 开启鼠标支持
set -g mouse on

# 历史记录行数
set -g history-limit 20000

# ---------------------------
# 键位绑定 (Keybindings)
# ---------------------------
# 使用 | 和 - 分割窗口，并在当前路径下打开
bind | split-window -h -c "#{pane_current_path}"
bind - split-window -v -c "#{pane_current_path}"
unbind '"'
unbind %

# 使用 r 重新加载配置文件
bind r source-file ~/.tmux.conf \; display "配置文件已重载！"

# 使用 Vim 风格的键位在窗格间移动
bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R

# 使用 Shift + 方向键调整窗格大小
bind -r H resize-pane -L 5
bind -r J resize-pane -D 5
bind -r K resize-pane -U 5
bind -r L resize-pane -R 5

# ---------------------------
# 外观与状态栏 (Appearance)
# ---------------------------
# 状态栏颜色
set -g status-bg colour235 # dark grey
set -g status-fg colour250 # light grey

# 状态栏内容
set -g status-left-length 40
set -g status-left "#[fg=green,bold]S: #S #[fg=yellow]W: #I #[fg=cyan]P: #P"

set -g status-right "#[fg=cyan]%Y-%m-%d %H:%M"
set -g status-justify centre

# 高亮当前窗口
setw -g window-status-current-style fg=white,bg=red,bold
setw -g window-status-current-format ' #I:#W#F '

# 非当前窗口
setw -g window-status-style fg=cyan,bg=default
setw -g window-status-format ' #I:#W#F '

# ---------------------------
# 插件管理 (TPM)
# ---------------------------
# 插件列表
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible' # 基本的 tmux 设置
set -g @plugin 'christoomey/vim-tmux-navigator' # Vim/Tmux 窗格无缝导航
set -g @plugin 'tmux-plugins/tmux-resurrect' # 保存和恢复 tmux 会话
set -g @plugin 'tmux-plugins/tmux-continuum' # 自动保存和恢复

# 初始化 TPM (必须放在最后)
run '~/.tmux/plugins/tpm/tpm'
EOF
}

# 步骤 10: 设置默认 Shell
set_default_shell() {
    print_info "设置 Zsh 为默认 Shell..."
    if [ "$(basename "$SHELL")" != "zsh" ]; then
        # 检查 zsh 是否在 /etc/shells 中
        if ! grep -q "$(which zsh)" /etc/shells; then
            print_info "将 zsh 添加到 /etc/shells..."
            command -v zsh | sudo tee -a /etc/shells
        fi
        sudo chsh -s "$(which zsh)" "$USER"
    else
        print_info "Zsh 已经是默认 Shell。"
    fi
}

# --- 最终说明 ---
print_final_instructions() {
    # shellcheck source=/dev/null
    source "$HOME/.cargo/env" # 确保 uv 在 PATH 中
    
    echo -e "\n\n"
    print_success "🚀🚀🚀 恭喜！高级终端环境已配置完成！ 🚀🚀🚀"
    echo -e "\n\e[1;33m>>> 请务必执行以下步骤以完成设置 <<<\e[0m"
    echo -e "\n\e[1;32m1. 【关键】配置本地终端字体:\e[0m"
    echo   "   为了让所有图标正确显示，你必须在 \e[1;31m你自己的电脑\e[0m 上的终端软件 (如 Windows Terminal, iTerm2, Kitty 等) 中，"
    echo   "   将字体设置为 \e[1;36m'FiraCode Nerd Font'\e[0m 或其他任意 'Nerd Font'。"
    echo   "   脚本已在服务器上为您下载了 FiraCode，但最终显示效果取决于您的本地终端设置。"

    echo -e "\n\e[1;32m2. 重新登录:\e[0m"
    echo   "   请 \e[1;31m完全断开当前的 SSH 连接，然后重新登录\e[0m。这将激活 Zsh 作为你的默认 Shell。"

    echo -e "\n\e[1;32m3. 安装 Tmux 插件:\e[0m"
    echo   "   重新登录后，输入 \e[1;36mtmux\e[0m 进入 Tmux。然后按下 \e[1;33mPrefix + I\e[0m (即 \e[1;32mCtrl+a\e[0m，然后按 \e[1;32m大写 I\e[0m) 来安装所有插件。"

    echo -e "\n\e[1;32m4. 使用 uv 管理 Python 环境 (可选):\e[0m"
    echo   "   - 创建一个 Python 3.11 的虚拟环境: \e[1;36muv venv -p 3.11 my-project\e[0m"
    echo   "   - 激活虚拟环境: \e[1;36msource my-project/bin/activate\e[0m"
    echo   "   - 在虚拟环境中安装包: \e[1;36muv pip install numpy pandas\e[0m"

    echo -e "\n\e[1;32m5. 安装 Node.js 版本 (可选):\e[0m"
    echo   "   - 安装最新的 LTS 版本的 Node.js: \e[1;36mnvm install --lts\e[0m"

    echo -e "\n\e[1;32m6. 配置 Neovim 和 AstroNvim:\e[0m"
    echo   "   - 启动 Neovim: \e[1;36mnvim\e[0m"
    echo   "   - 首次启动时，AstroNvim 会自动安装插件，请耐心等待"
    echo   "   - 安装语言服务器: \e[1;36m:LspInstall <language>\e[0m (例如: \e[1;36m:LspInstall pyright\e[0m)"
    echo   "   - 安装语言解析器: \e[1;36m:TSInstall <language>\e[0m (例如: \e[1;36m:TSInstall python\e[0m)"
    echo   "   - 安装调试器: \e[1;36m:DapInstall <debugger>\e[0m (例如: \e[1;36m:DapInstall python\e[0m)"
    echo   "   - 更新插件: \e[1;36m:Lazy update\e[0m 或使用快捷键 \e[1;33m<Leader>pU\e[0m"
    echo   "   - 检查 AstroNvim 状态: \e[1;36m:AstroVersion\e[0m"

    echo -e "\n享受你全新的、强大的终端环境和现代化的 Neovim 编辑器吧！"
}


# --- 主执行流程 ---
main() {
    setup_environment
    run_step "system_dependencies" install_system_dependencies
    run_step "nerd_font" install_nerd_font
    run_step "backup_configs" backup_configs
    run_step "core_tools" install_core_tools
    run_step "neovim" install_neovim
    run_step "astronvim_dependencies" install_astronvim_dependencies
    run_step "astronvim" install_astronvim
    run_step "language_managers" install_language_managers
    run_step "configure_zsh" configure_zsh
    run_step "configure_starship" configure_starship
    run_step "configure_tmux" configure_tmux
    run_step "set_default_shell" set_default_shell
    print_final_instructions
}

# --- 脚本入口 ---
main "$@"

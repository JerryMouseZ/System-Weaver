#!/bin/bash
# ==============================================================================
#                 现代化桌面环境自动配置脚本 (KDE Neon/Plasma 6)
#
# 脚本特性:
# 1. 模块化设计: 所有功能封装在函数中，清晰易维护。
# 2. 断点续传: 自动跳过已成功执行的步骤，可从失败处继续。
# 3. 智能检测: 自动检测已安装的软件，避免重复安装。
# 4. 权限管理: 智能处理 sudo 权限，确保安全性。
# 5. 自动化配置:
#    - 安装输入法 (Fcitx5) 和中文支持
#    - 安装现代浏览器 (Google Chrome)
#    - 安装 Flatpak 应用生态
#    - 安装开发工具 (VS Code)
#    - 配置应用权限和系统环境
#
# @version: 2.0 (Modular & Resumable Edition)
# ==============================================================================

# --- 安全设置 ---
# 如果任何命令失败，立即退出脚本
set -e
# 如果管道中的任何命令失败，则整个管道的返回码为非零
set -o pipefail

# --- 状态与常量定义 ---
STATE_DIR="/tmp/.desktop_setup_state"
ORIGINAL_USER="${SUDO_USER:-$USER}"
ORIGINAL_HOME=$(eval echo "~$ORIGINAL_USER")

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

# --- 权限检查与环境初始化 ---
check_permissions() {
    if [ "$(id -u)" -ne 0 ]; then
        print_error "此脚本需要 root 权限。请使用 sudo 运行: sudo ./desktop.sh"
    fi

    if [ -z "$ORIGINAL_USER" ] || [ "$ORIGINAL_USER" = "root" ]; then
        print_error "无法确定原始用户。请不要直接以 root 用户运行此脚本。"
    fi

    print_info "检测到用户: $ORIGINAL_USER"
    print_info "用户主目录: $ORIGINAL_HOME"
}

# --- 模块化功能函数 ---

# 步骤 0: 初始化环境
setup_environment() {
    print_info "初始化环境，创建状态目录..."
    mkdir -p "$STATE_DIR"
    check_permissions
    print_info "=== 开始桌面环境配置 ==="
}

# 步骤 1: 更新系统包列表
update_system_packages() {
    print_info "更新系统包列表..."
    apt-get update || return 1
    print_success "系统包列表更新完成。"
}

# 步骤 2: 安装输入法 (Fcitx5)
install_input_method() {
    print_info "安装 Fcitx5 输入法框架..."

    # 检查是否已安装
    if dpkg -l | grep -q "fcitx5 "; then
        print_info "Fcitx5 已安装。"
        return 0
    fi

    # 安装 Fcitx5 相关包
    # fcitx5: 核心框架
    # fcitx5-chinese-addons: 中文输入支持 (拼音、五笔等)
    # kde-config-fcitx5: KDE 系统设置集成
    apt-get install -y fcitx5 fcitx5-chinese-addons kde-config-fcitx5 || return 1

    print_info "配置输入法环境变量..."
    # 配置系统级环境变量，使 Fcitx5 可被所有应用使用 (GTK, Qt 等)
    local env_vars=(
        "GTK_IM_MODULE=fcitx"
        "QT_IM_MODULE=fcitx"
        "XMODIFIERS=@im=fcitx"
    )

    for var in "${env_vars[@]}"; do
        if ! grep -q "$var" /etc/environment; then
            echo "$var" | tee -a /etc/environment > /dev/null
            print_info "添加环境变量: $var"
        fi
    done

    print_success "Fcitx5 安装完成。重启后可在 '系统设置 -> 输入设备 -> 虚拟键盘' 中配置。"
}

# 步骤 3: 安装 Google Chrome
install_google_chrome() {
    print_info "安装 Google Chrome..."

    # 检查是否已安装
    if command -v google-chrome &> /dev/null; then
        print_info "Google Chrome 已安装。"
        return 0
    fi

    # 添加 Google 官方 GPG 密钥 (使用现代安全方法)
    print_info "添加 Google GPG 密钥..."
    wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | \
        gpg --dearmor -o /usr/share/keyrings/google-chrome-keyring.gpg || return 1

    # 添加 Chrome 软件源
    print_info "添加 Chrome 软件源..."
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome-keyring.gpg] http://dl.google.com/linux/chrome/deb/ stable main" | \
        tee /etc/apt/sources.list.d/google-chrome.list > /dev/null

    # 更新包列表并安装 Chrome
    print_info "安装 Google Chrome..."
    apt-get update || return 1
    apt-get install -y google-chrome-stable || return 1

    print_success "Google Chrome 安装完成。"
}

# 步骤 4: 安装 Flatpak 和应用
install_flatpak_applications() {
    print_info "配置 Flatpak 和安装应用..."

    # 确保 Flatpak 已安装
    if ! command -v flatpak &> /dev/null; then
        print_info "安装 Flatpak..."
        apt-get install -y flatpak || return 1
    fi

    # 添加 Flathub 软件源 (Flatpak 应用的主要来源)
    print_info "添加 Flathub 软件源..."
    flatpak remote-add-if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo || return 1

    # 定义要安装的应用列表
    local flatpak_apps=(
        "cn.feishu.Feishu"                                    # 飞书
        "com.github.gmg137.netease-cloud-music-gtk"          # 网易云音乐
        "com.tencent.WeChat"                                  # 微信
        "io.github.getnf.embellish"                           # 字体管理器
        "org.zotero.Zotero"                                   # 文献管理
    )

    # 安装应用
    print_info "安装 Flatpak 应用..."
    for app in "${flatpak_apps[@]}"; do
        if flatpak list | grep -q "$app"; then
            print_info "$app 已安装，跳过。"
        else
            print_info "安装 $app..."
            flatpak install -y flathub "$app" || print_warning "$app 安装失败，继续安装其他应用。"
        fi
    done

    print_info "配置 Flatpak 应用权限..."
    # 为飞书授予完整文件系统访问权限 (用于无缝文件共享和集成)
    flatpak override --filesystem=host cn.feishu.Feishu 2>/dev/null || true

    # 为其他应用授予主目录访问权限 (用于附件、保存文件等常见用例)
    local home_access_apps=(
        "com.tencent.WeChat"
        "org.zotero.Zotero"
        "com.github.gmg137.netease-cloud-music-gtk"
        "io.github.getnf.embellish"
    )

    for app in "${home_access_apps[@]}"; do
        flatpak override --filesystem=home "$app" 2>/dev/null || true
    done

    print_success "Flatpak 应用安装和权限配置完成。"
}

# 步骤 5: 安装开发工具 (VS Code)
install_development_tools() {
    print_info "安装开发工具..."

    # 检查 VS Code 是否已安装
    if command -v code &> /dev/null; then
        print_info "Visual Studio Code 已安装。"
        return 0
    fi

    print_info "安装 Visual Studio Code..."
    # 添加 Microsoft GPG 密钥
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | \
        gpg --dearmor | tee /usr/share/keyrings/packages.microsoft.gpg > /dev/null || return 1

    # 添加 VS Code 软件源
    echo "deb [arch=amd64,arm64,armhf signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | \
        tee /etc/apt/sources.list.d/vscode.list > /dev/null

    # 更新包列表并安装
    apt-get update || return 1
    apt-get install -y code || return 1

    print_success "Visual Studio Code 安装完成。"
}

# --- 最终说明 ---
print_final_instructions() {
    echo -e "\n\n"
    print_success "🎉🎉🎉 恭喜！桌面环境配置完成！ 🎉🎉🎉"
    echo -e "\n\e[1;33m>>> 请务必执行以下步骤以完成设置 <<<\e[0m"

    echo -e "\n\e[1;32m1. 【重要】重启系统:\e[0m"
    echo   "   \e[1;31m系统重启是必需的\e[0m，以使所有更改生效。"
    echo   "   重启命令: \e[1;36msudo reboot\e[0m"

    echo -e "\n\e[1;32m2. 配置输入法:\e[0m"
    echo   "   重启后，打开 \e[1;36m系统设置 -> 输入设备 -> 虚拟键盘\e[0m"
    echo   "   选择 Fcitx5 作为输入法，并配置中文输入。"

    echo -e "\n\e[1;32m3. 已安装的应用:\e[0m"
    echo   "   - \e[1;36mGoogle Chrome\e[0m: 现代网页浏览器"
    echo   "   - \e[1;36m飞书 (Feishu)\e[0m: 企业协作平台"
    echo   "   - \e[1;36m微信 (WeChat)\e[0m: 即时通讯工具"
    echo   "   - \e[1;36m网易云音乐\e[0m: 音乐播放器"
    echo   "   - \e[1;36mZotero\e[0m: 文献管理工具"
    echo   "   - \e[1;36mEmbellish\e[0m: 字体管理器"
    echo   "   - \e[1;36mVisual Studio Code\e[0m: 代码编辑器"

    echo -e "\n\e[1;32m4. 使用提示:\e[0m"
    echo   "   - Flatpak 应用可在应用启动器中找到"
    echo   "   - 如需安装更多 Flatpak 应用: \e[1;36mflatpak install flathub <应用ID>\e[0m"
    echo   "   - 查看已安装的 Flatpak 应用: \e[1;36mflatpak list\e[0m"

    echo -e "\n享受你的现代化桌面环境吧！"
}

# --- 主执行流程 ---
main() {
    setup_environment
    run_step "update_packages" update_system_packages
    run_step "input_method" install_input_method
    run_step "google_chrome" install_google_chrome
    run_step "flatpak_apps" install_flatpak_applications
    run_step "development_tools" install_development_tools
    print_final_instructions
}

# --- 脚本入口 ---
main "$@"

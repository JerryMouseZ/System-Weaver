# System-Weaver: 现代化开发环境一键配置

`System-Weaver` 是一个强大的自动化脚本集合，旨在为基于 Debian/Ubuntu 的 Linux 系统一键部署完整的现代化开发环境。包含终端环境配置和桌面应用安装两个核心脚本，让你快速搭建高效的工作环境。

## 🚀 脚本概览

### 📟 server.sh - 终端环境配置
现代化终端环境自动配置脚本，集成 Zsh、Tmux、Neovim (AstroNvim)、Starship 等一系列优秀工具。

### 🖥️ desktop.sh - 桌面应用安装
桌面环境应用自动安装脚本，包含输入法、浏览器、办公软件、开发工具等常用应用。

## 🌟 核心特性

### 🔧 通用特性
- **模块化设计**: 所有功能封装在函数中，逻辑清晰，易于维护和自定义
- **断点续传**: 自动跳过已成功执行的步骤，可从失败处重新运行
- **智能检测**: 自动检测已安装的软件，避免重复安装
- **错误处理**: 完善的错误处理和日志输出，便于问题排查

### 📟 server.sh 特性
- **现代化终端**: Zsh + Zinit + Starship + Tmux 完整终端环境
- **强大编辑器**: Neovim v0.11+ + AstroNvim 配置，支持 LSP、调试、插件管理
- **开发工具链**:
  - 语言管理器: NVM (Node.js)、Rustup (Rust)、uv (Python)
  - 系统工具: ripgrep、fzf、lazygit、gdu、bottom、Tree-sitter
  - 字体支持: FiraCode Nerd Font 自动安装
- **自动配置**: 生成优化的 `.zshrc`、`.tmux.conf`、`starship.toml` 配置文件

### 🖥️ desktop.sh 特性
- **输入法支持**: Fcitx5 + 中文输入法，完整的多语言输入支持
- **现代浏览器**: Google Chrome 官方版本
- **办公应用**: 飞书、微信、网易云音乐、Zotero 文献管理
- **开发工具**: Visual Studio Code、字体管理器
- **沙盒安全**: 基于 Flatpak 的应用隔离和权限管理

## 🚀 快速开始

### 📥 获取脚本
```bash
git clone https://github.com/your-username/System-Weaver.git
cd System-Weaver
chmod +x *.sh
```

### 📟 配置终端环境 (server.sh)
```bash
# 普通用户运行，会自动请求 sudo 权限
./server.sh
```

**适用场景**: 服务器、开发机、WSL、虚拟机等需要强大终端环境的场景

### 🖥️ 安装桌面应用 (desktop.sh)
```bash
# 需要 sudo 权限运行
sudo ./desktop.sh
```

**适用场景**: KDE Neon、Ubuntu Desktop、Kubuntu 等桌面环境

### 📋 推荐安装顺序
1. **先运行 server.sh** - 配置基础终端环境
2. **重新登录** - 激活 Zsh 和相关配置
3. **再运行 desktop.sh** - 安装桌面应用
4. **重启系统** - 激活输入法和桌面应用

## 📋 详细安装流程

### 📟 server.sh 执行步骤
1. **环境初始化** - 创建状态目录，检查权限
2. **系统依赖** - 安装 build-essential、zsh、tmux、git 等基础包
3. **字体安装** - 下载安装 FiraCode Nerd Font
4. **配置备份** - 自动备份现有的 shell 和 tmux 配置
5. **核心工具** - 安装 Zinit、Starship、colorls、TPM、uv
6. **fzf 安装** - 安装 fzf 模糊查找工具及键位绑定
7. **Neovim 安装** - 下载最新 Neovim AppImage (v0.11+)
8. **AstroNvim 依赖** - 安装 ripgrep、lazygit、tree-sitter、gdu、bottom
9. **AstroNvim 配置** - 克隆官方模板，配置开发环境
10. **语言管理器** - 安装 NVM (Node.js)、Rustup (Rust)
11. **Docker 配置** - 安装并配置 Docker，数据根目录设置为 /home/docker
12. **配置生成** - 创建 .zshrc、.tmux.conf、starship.toml
13. **Shell 设置** - 将 Zsh 设为默认 Shell

### 🖥️ desktop.sh 执行步骤
1. **环境初始化** - 检查权限，创建状态目录
2. **系统更新** - 更新包列表
3. **输入法安装** - 安装 Fcitx5 + 中文输入法 + KDE 集成
4. **浏览器安装** - 添加 Google 源，安装 Chrome
5. **Flatpak 配置** - 添加 Flathub 源，安装沙盒应用
6. **开发工具** - 安装 Visual Studio Code

## ⚠️ 重要后续步骤

### 📟 server.sh 完成后
1. **配置终端字体** 🎨
   - 在你的**本地终端软件**中设置字体为 `FiraCode Nerd Font`
   - 支持的终端: Windows Terminal、iTerm2、Kitty、Alacritty 等
   - 这是显示图标和符号的关键步骤

2. **重新登录** 🔄
   - 完全断开 SSH 连接并重新登录
   - 激活 Zsh 作为默认 Shell

3. **安装 Tmux 插件** 🔌
   - 启动 tmux: `tmux`
   - 按 `Ctrl+a` 然后按 `I` (大写) 安装插件

4. **配置 Neovim** ⚡
   - 启动 Neovim: `nvim`
   - 等待 AstroNvim 自动安装插件
   - 安装语言服务器: `:LspInstall <language>`

### 🖥️ desktop.sh 完成后
1. **系统重启** 🔄
   - **必须重启**以激活输入法和所有更改
   - 重启命令: `sudo reboot`

2. **配置输入法** ⌨️
   - 打开 `系统设置 -> 输入设备 -> 虚拟键盘`
   - 选择 Fcitx5 并配置中文输入

3. **启动应用** 🚀
   - 所有 Flatpak 应用可在应用启动器中找到
   - Chrome、VS Code 等可直接使用

## 📦 已安装应用清单

### 📟 终端环境 (server.sh)
- **Shell**: Zsh + Zinit 插件管理
- **终端复用**: Tmux + 插件生态
- **编辑器**: Neovim v0.11+ + AstroNvim
- **提示符**: Starship (pastel-powerline 主题)
- **搜索工具**: fzf (模糊查找)、ripgrep (内容搜索)
- **开发工具**: lazygit、gdu、bottom
- **语言环境**: NVM、Rustup、uv
- **容器工具**: Docker
- **字体**: FiraCode Nerd Font

### 🖥️ 桌面应用 (desktop.sh)
- **浏览器**: Google Chrome
- **输入法**: Fcitx5 + 中文输入法
- **办公协作**: 飞书 (Feishu)
- **即时通讯**: 微信 (WeChat)
- **音乐娱乐**: 网易云音乐
- **学术工具**: Zotero 文献管理
- **字体管理**: Embellish
- **代码编辑**: Visual Studio Code

## 💡 使用技巧

### 📟 终端环境使用
```bash
# Zsh 快捷操作
z <目录名>              # 快速跳转到常用目录
ll                     # 带图标的详细文件列表
tree                   # 树形目录结构

# fzf 模糊查找 (按键绑定)
Ctrl+T                 # 模糊搜索文件并粘贴到命令行
Ctrl+R                 # 模糊搜索历史命令
Alt+C                  # 模糊搜索并跳转到目录
fcd                    # 使用 fzf 快速跳转到子目录

# Tmux 操作 (前缀键: Ctrl+a)
Ctrl+a + |            # 水平分割窗格
Ctrl+a + -            # 垂直分割窗格
Ctrl+a + h/j/k/l      # Vim 风格窗格导航

# Neovim + AstroNvim
<Space>ff              # 文件搜索
<Space>fw              # 全文搜索
<Space>tl              # 打开 lazygit
:LspInstall pyright    # 安装 Python LSP
```

### 🖥️ 桌面应用使用
```bash
# Flatpak 应用管理
flatpak list           # 查看已安装应用
flatpak update         # 更新所有应用
flatpak uninstall <ID> # 卸载应用

# 输入法切换
Ctrl+Space             # 切换输入法 (默认快捷键)
```

## 🔧 自定义配置

### 添加更多 Flatpak 应用
```bash
# 搜索应用
flatpak search <关键词>

# 安装应用
sudo flatpak install flathub <应用ID>

# 常用应用推荐
sudo flatpak install flathub org.telegram.desktop    # Telegram
sudo flatpak install flathub com.discordapp.Discord  # Discord
sudo flatpak install flathub org.gimp.GIMP          # GIMP
sudo flatpak install flathub org.blender.Blender    # Blender
```

### 自定义 Zsh 配置
编辑 `~/.zshrc` 添加个人配置:
```bash
# 添加自定义别名
alias ll='eza -la --icons --git'
alias cat='bat'
alias find='fd'

# 添加自定义函数
mkcd() { mkdir -p "$1" && cd "$1"; }
```

## 🚨 故障排除

### 常见问题

#### 1. 字体显示异常
**问题**: 终端中图标显示为方块或问号
**解决**: 确保本地终端使用 Nerd Font 字体

#### 2. Zsh 插件加载失败
**问题**: 语法高亮或自动建议不工作
**解决**:
```bash
# 重新安装 Zinit
rm -rf ~/.local/share/zinit
./server.sh  # 重新运行脚本
```

#### 3. Neovim 版本过低
**问题**: AstroNvim 提示版本不兼容
**解决**:
```bash
# 删除旧版本重新安装
rm ~/.local/bin/nvim*
./server.sh  # 重新运行脚本
```

#### 4. 输入法无法切换
**问题**: Fcitx5 安装后无法使用
**解决**:
```bash
# 检查环境变量
echo $GTK_IM_MODULE
echo $QT_IM_MODULE

# 重启输入法服务
killall fcitx5
fcitx5 &
```

#### 5. Flatpak 应用无法启动
**问题**: 点击应用图标无响应
**解决**:
```bash
# 从终端启动查看错误信息
flatpak run <应用ID>

# 重置应用权限
sudo flatpak override --reset <应用ID>
```

### 获取帮助
- 查看详细文档: [README_COMPREHENSIVE.md](README_COMPREHENSIVE.md)
- 提交问题: GitHub Issues
- 检查日志: 脚本运行时的输出信息

## 🤝 贡献指南

欢迎提交 Issue 和 Pull Request！

### 开发环境
```bash
# 克隆仓库
git clone https://github.com/your-username/System-Weaver.git
cd System-Weaver

# 测试脚本语法
bash -n server.sh
bash -n desktop.sh

# 在虚拟机中测试
# 推荐使用 Ubuntu 22.04 LTS 或 KDE Neon
```

### 提交规范
- 功能添加: `feat: 添加新功能描述`
- 问题修复: `fix: 修复问题描述`
- 文档更新: `docs: 更新文档内容`
- 代码重构: `refactor: 重构代码逻辑`

---

**享受你的现代化开发环境！** 🎉✨

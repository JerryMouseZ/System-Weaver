# System-Weaver: 现代化终端环境一键配置

`System-Weaver` 是一个强大的自动化脚本，旨在为基于 Debian/Ubuntu 的 Linux 系统一键部署一个现代化、高效且美观的终端环境。它集成了 Zsh、Tmux、Starship、Zinit 等一系列优秀工具，并自动完成配置，让你专注于真正的工作。

## 核心特性

- **自动化部署**: 无需手动干预，一键安装和配置所有必需的工具。
- **模块化设计**: 脚本逻辑清晰，易于理解和自定义。
- **断点续传**: 自动跳过已成功执行的步骤，可从失败处重新运行。
- **轻量高效**: 使用 `Zinit` 作为 Zsh 插件管理器，替代了庞大的 Oh-My-Zsh，启动速度更快。
- **现代化工具链**: 
    - 使用 `Starship` 提供美观、可定制的跨 Shell 提示符。
    - 使用 `colorls` 美化 `ls` 命令的输出。
    - 集成 `uv`，一个用 Rust 编写的高性能 Python 包管理器。
    - 预置 `nvm` (Node.js 版本管理器) 和 `rustup` (Rust 工具链)。
- **预配置优化**: 
    - 自动生成功能丰富的 `.zshrc` 和 `.tmux.conf` 配置文件。
    - 自动安装 `FiraCode Nerd Font` 以确保所有图标正常显示。

## 使用方法

1.  **克隆仓库**
    ```bash
    git clone https://github.com/your-username/System-Weaver.git
    cd System-Weaver
    ```

2.  **授予执行权限**
    ```bash
    chmod +x server.sh
    ```

3.  **运行脚本**
    ```bash
    ./server.sh
    ```
    脚本会请求 `sudo` 权限以安装系统依赖。请根据提示输入你的密码。

## 自动化流程

该脚本将自动执行以下步骤：

1.  **环境初始化**: 创建用于跟踪进度的状态目录。
2.  **安装系统依赖**: 安装 `zsh`, `tmux`, `git`, `curl` 等基础软件包。
3.  **安装 Nerd Font**: 下载并安装 `FiraCode Nerd Font`。
4.  **备份现有配置**: 自动备份你现有的 `.zshrc`, `.tmux.conf` 等配置文件。
5.  **安装核心工具**: 安装 `Zinit`, `Starship`, `colorls`, `fzf` 等。
6.  **安装语言环境**: 安装 `nvm`, `rustup`, 和 `uv`。
7.  **生成配置文件**: 创建优化过的 `.zshrc`, `starship.toml`, 和 `.tmux.conf`。
8.  **设置默认 Shell**: 将 Zsh 设置为你的默认登录 Shell。

## 关键：后续步骤

脚本执行完毕后，请务必完成以下步骤：

1.  **配置本地终端字体**: 
    为了让所有图标和符号正确显示，你必须在你 **自己的电脑** 上的终端软件 (如 Windows Terminal, iTerm2, Kitty 等) 中，将字体设置为 **`FiraCode Nerd Font`** 或其他任意 Nerd Font 字体。

2.  **重新登录**: 
    **完全断开当前的 SSH 连接，然后重新登录**。这将激活 Zsh 作为你的默认 Shell。

3.  **安装 Tmux 插件**: 
    重新登录后，输入 `tmux` 进入 Tmux 环境。然后按下 `Prefix + I` (即 **Ctrl+a**，然后按 **大写 I** 键) 来安装所有 Tmux 插件。

现在，你可以享受全新的、强大的终端环境了！

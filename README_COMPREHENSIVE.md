# System-Weaver: Complete Development Environment Setup

A comprehensive, automated script that transforms your Ubuntu/Debian system into a modern, powerful development environment with Zsh, Tmux, Neovim with AstroNvim, and essential development tools.

## 🚀 Quick Start

```bash
git clone https://github.com/your-username/System-Weaver.git
cd System-Weaver
chmod +x server.sh
./server.sh
```

## 📦 Complete Feature List

### 🖥️ Terminal Environment
- **Zsh**: Modern shell with advanced features
- **Zinit**: Fast, lightweight plugin manager (replaces Oh-My-Zsh)
- **Starship**: Cross-platform, customizable prompt with Git integration
- **FiraCode Nerd Font**: Programming font with ligatures and icons

### 🔧 Development Tools
- **Neovim v0.11+**: Latest version via AppImage (bypasses outdated apt packages)
- **AstroNvim**: Feature-rich Neovim configuration with LSP, debugging, and modern UI
- **Tmux**: Terminal multiplexer with custom configuration and plugin management
- **Git**: Version control with enhanced utilities

### 🌐 Language Managers
- **NVM**: Node.js Version Manager for JavaScript/TypeScript development
- **Rustup**: Rust toolchain installer and version manager
- **uv**: Ultra-fast Python package manager (written in Rust)

### 🛠️ System Utilities
- **ripgrep (rg)**: Ultra-fast text search tool
- **lazygit**: Terminal UI for Git operations
- **Tree-sitter CLI**: Syntax highlighting and code parsing
- **gdu**: Fast disk usage analyzer
- **bottom (btm)**: System resource monitor
- **colorls**: Enhanced `ls` command with colors and icons

### 🎨 Visual Enhancements
- **Icons**: Comprehensive icon support via Nerd Fonts
- **Syntax Highlighting**: Advanced syntax highlighting in terminal and editor
- **Themes**: Pastel Powerline theme for Starship prompt

## ⌨️ Keyboard Shortcuts & Commands

### Tmux Key Bindings
**Prefix Key**: `Ctrl+a` (instead of default `Ctrl+b`)

#### Window & Pane Management
- `Prefix + |` - Split window horizontally
- `Prefix + -` - Split window vertically
- `Prefix + h/j/k/l` - Navigate panes (Vim-style)
- `Prefix + H/J/K/L` - Resize panes
- `Prefix + r` - Reload Tmux configuration

#### Plugin Management
- `Prefix + I` - Install Tmux plugins (TPM)
- `Prefix + U` - Update plugins
- `Prefix + Alt+u` - Uninstall plugins

### AstroNvim/Neovim Shortcuts
**Leader Key**: `<Space>` (default AstroNvim leader)

#### File Operations
- `<Leader>ff` - Find files (fuzzy finder)
- `<Leader>fw` - Find word in files (live grep)
- `<Leader>fb` - Find buffers
- `<Leader>fh` - Find help tags
- `<Leader>fo` - Find old files

#### LSP (Language Server Protocol)
- `gd` - Go to definition
- `gr` - Go to references
- `K` - Show hover information
- `<Leader>ca` - Code actions
- `<Leader>rn` - Rename symbol
- `]d` / `[d` - Next/previous diagnostic

#### Plugin Management
- `<Leader>pS` - Sync plugins (Lazy.nvim)
- `<Leader>pU` - Update plugins
- `<Leader>pu` - Check for updates
- `<Leader>pa` - AstroUpdate (update both plugins and Mason packages)

#### Terminal Integration
- `<Leader>tf` - Toggle floating terminal
- `<Leader>th` - Toggle horizontal terminal
- `<Leader>tv` - Toggle vertical terminal
- `<Leader>tl` - Toggle lazygit
- `<Leader>tn` - Toggle Node REPL
- `<Leader>tp` - Toggle Python REPL
- `<Leader>tt` - Toggle bottom (system monitor)
- `<Leader>tu` - Toggle gdu (disk usage)

### Zsh Shortcuts & Aliases
#### Custom Aliases
- `ls` → `eza --icons` - Enhanced ls with icons
- `ll` → `eza -l --icons` - Long format with icons
- `la` → `eza -la --icons` - All files with icons
- `tree` → `eza --tree --icons` - Tree view with icons

#### Zinit Plugin Features
- **Auto-suggestions**: Type and get suggestions from history
- **Syntax Highlighting**: Real-time command syntax highlighting
- **Directory Jumping**: Use `z <partial-name>` to jump to frequently used directories

## 💡 Usage Examples

### Setting Up Development Environments

#### Python Development
```bash
# Install Python version and create virtual environment
uv venv -p 3.11 my-project
source my-project/bin/activate
uv pip install numpy pandas fastapi

# In Neovim
:LspInstall pyright
:TSInstall python
:DapInstall python
```

#### Node.js Development
```bash
# Install and use Node.js LTS
nvm install --lts
nvm use --lts

# In Neovim
:LspInstall ts_ls
:TSInstall javascript typescript
:DapInstall node2
```

#### Rust Development
```bash
# Rust is already installed via rustup
cargo new my-project
cd my-project

# In Neovim
:LspInstall rust_analyzer
:TSInstall rust
:DapInstall codelldb
```

### Using LSP Features in Neovim

#### Installing Language Servers
```vim
:LspInstall pyright          " Python
:LspInstall ts_ls            " TypeScript/JavaScript
:LspInstall rust_analyzer    " Rust
:LspInstall gopls            " Go
:LspInstall clangd           " C/C++
:LspInstall lua_ls           " Lua
```

#### Installing Syntax Parsers
```vim
:TSInstall python javascript typescript rust go c cpp lua
:TSInstall html css json yaml toml markdown
```

#### Installing Debuggers
```vim
:DapInstall python           " Python debugger
:DapInstall node2            " Node.js debugger
:DapInstall codelldb         " Rust/C++ debugger
```

### Git Workflow with lazygit
```bash
# Open lazygit in terminal
lazygit

# Or from within Neovim
<Leader>tl
```

**lazygit Key Bindings:**
- `j/k` - Navigate up/down
- `<Space>` - Stage/unstage files
- `c` - Commit
- `P` - Push
- `p` - Pull
- `q` - Quit

### File Searching with ripgrep
```bash
# Search for text in files
rg "function" --type py        # Search in Python files
rg "TODO" -A 3 -B 3           # Show 3 lines before/after
rg "pattern" --hidden         # Include hidden files
```

### System Monitoring
```bash
# Disk usage analysis
gdu

# System resource monitoring
btm
# or
bottom
```

## 🔧 Configuration Details

### Customizing AstroNvim

#### Adding Custom Plugins
Edit `~/.config/nvim/lua/plugins/user.lua`:
```lua
return {
  {
    "your-plugin/name",
    config = function()
      -- Plugin configuration
    end,
  },
}
```

#### Customizing Key Mappings
Edit `~/.config/nvim/lua/plugins/astrocore.lua`:
```lua
return {
  "AstroNvim/astrocore",
  opts = {
    mappings = {
      n = {
        ["<Leader>custom"] = { "<cmd>YourCommand<cr>", desc = "Your custom command" },
      },
    },
  },
}
```

### Adding Zsh Plugins via Zinit

Edit `~/.zshrc` and add to the Zinit section:
```bash
# Add new plugin
zinit light "author/plugin-name"

# Add plugin with specific loading conditions
zinit ice wait"1" lucid
zinit light "author/another-plugin"
```

### Modifying Tmux Settings

Edit `~/.tmux.conf`:
```bash
# Add custom key bindings
bind-key C-h select-window -t :-
bind-key C-l select-window -t :+

# Reload configuration
tmux source-file ~/.tmux.conf
```

### Changing Starship Prompt Themes

```bash
# List available presets
starship preset --list

# Apply a different preset
starship preset nerd-font-symbols -o ~/.config/starship.toml
```

## 🔄 Maintenance Commands

### Updating the Environment
```bash
# Update all package managers
sudo apt update && sudo apt upgrade

# Update Rust
rustup update

# Update Node.js to latest LTS
nvm install --lts --reinstall-packages-from=current

# Update Python packages
uv pip list --outdated
```

### Neovim Maintenance
```vim
:AstroUpdate                 " Update AstroNvim and Mason packages
:Lazy update                 " Update plugins
:Mason                       " Manage LSP servers, formatters, linters
:checkhealth                 " Check Neovim health
```

### Tmux Plugin Management
```bash
# In Tmux session
Prefix + I                   # Install new plugins
Prefix + U                   # Update plugins
Prefix + Alt+u               # Remove unused plugins
```

## 🚨 Troubleshooting

### Common Issues

#### Neovim Version Issues
If AstroNvim complains about Neovim version:
```bash
# Check current version
nvim --version

# Reinstall latest version
rm ~/.local/bin/nvim*
./server.sh  # Re-run the script
```

#### Font Display Issues
- Ensure your terminal emulator uses a Nerd Font
- Popular choices: FiraCode Nerd Font, JetBrains Mono Nerd Font
- Configure in your terminal settings, not on the server

#### Plugin Installation Failures
```vim
" In Neovim, check plugin status
:Lazy
:Mason
:checkhealth
```

#### Tmux Plugin Issues
```bash
# Reinstall TPM
rm -rf ~/.tmux/plugins/tpm
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# Then: Prefix + I
```

## 📁 File Structure

```
~/.config/
├── nvim/                    # AstroNvim configuration
│   ├── lua/
│   │   ├── plugins/         # Plugin configurations
│   │   └── community.lua    # AstroCommunity imports
│   └── init.lua
├── starship.toml           # Starship prompt configuration
~/.local/
├── bin/
│   └── nvim                # Neovim AppImage symlink
└── share/
    ├── fonts/              # Nerd Fonts
    └── zinit/              # Zinit installation
~/.tmux/
└── plugins/                # Tmux plugins
~/.zshrc                    # Zsh configuration
~/.tmux.conf               # Tmux configuration
```

## 🎯 Next Steps

After installation:

1. **Restart your terminal session** to activate Zsh
2. **Configure your terminal font** to a Nerd Font
3. **Start Tmux** and install plugins: `tmux` → `Prefix + I`
4. **Launch Neovim** and let AstroNvim install: `nvim`
5. **Install language servers** for your development needs
6. **Explore the shortcuts** and customize to your workflow

Enjoy your powerful, modern development environment! 🚀

## 📚 Advanced Configuration Examples

### AstroNvim Language Pack Setup

#### Python Development Pack
```lua
-- In ~/.config/nvim/lua/community.lua
return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.pack.python" },
  { import = "astrocommunity.pack.docker" },
  { import = "astrocommunity.pack.json" },
  { import = "astrocommunity.pack.yaml" },
}
```

#### Web Development Pack
```lua
-- In ~/.config/nvim/lua/community.lua
return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.pack.typescript" },
  { import = "astrocommunity.pack.html-css" },
  { import = "astrocommunity.pack.tailwindcss" },
  { import = "astrocommunity.pack.vue" },
  { import = "astrocommunity.pack.react" },
}
```

### Custom Zsh Functions

Add to `~/.zshrc`:
```bash
# Quick project setup
mkproject() {
    mkdir -p "$1" && cd "$1"
    git init
    echo "# $1" > README.md
    echo "node_modules/\n.env\n*.log" > .gitignore
}

# Fast directory navigation with fzf
fcd() {
    local dir
    dir=$(find ${1:-.} -type d 2> /dev/null | fzf +m) && cd "$dir"
}

# Git shortcuts
alias gst="git status"
alias gco="git checkout"
alias gcb="git checkout -b"
alias gp="git push"
alias gl="git pull"
alias ga="git add"
alias gc="git commit"
```

### Tmux Advanced Configuration

Add to `~/.tmux.conf`:
```bash
# Custom session management
bind-key S command-prompt -p "New Session:" "new-session -A -s '%%'"
bind-key K confirm kill-session

# Window management
bind-key -n M-h previous-window
bind-key -n M-l next-window
bind-key -n M-1 select-window -t 1
bind-key -n M-2 select-window -t 2
bind-key -n M-3 select-window -t 3

# Copy mode improvements
bind-key -T copy-mode-vi v send-keys -X begin-selection
bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "xclip -in -selection clipboard"
```

## 🔍 Detailed Command Reference

### Neovim LSP Commands
```vim
" Language Server Management
:LspInfo                     " Show LSP client info
:LspStart <server>           " Start specific LSP server
:LspStop <server>            " Stop specific LSP server
:LspRestart                  " Restart LSP servers

" Diagnostics
:lua vim.diagnostic.open_float()  " Show diagnostic in floating window
:lua vim.diagnostic.setloclist()  " Add diagnostics to location list

" Code Navigation
:lua vim.lsp.buf.declaration()    " Go to declaration
:lua vim.lsp.buf.definition()     " Go to definition
:lua vim.lsp.buf.implementation() " Go to implementation
:lua vim.lsp.buf.type_definition() " Go to type definition

" Code Actions
:lua vim.lsp.buf.code_action()    " Show code actions
:lua vim.lsp.buf.format()         " Format current buffer
:lua vim.lsp.buf.rename()         " Rename symbol
```

### Mason Package Management
```vim
:Mason                       " Open Mason UI
:MasonInstall <package>      " Install package
:MasonUninstall <package>    " Uninstall package
:MasonUpdate                 " Update all packages
:MasonLog                    " Show installation logs
```

### Tree-sitter Commands
```vim
:TSInstall <language>        " Install parser
:TSUninstall <language>      " Uninstall parser
:TSUpdate                    " Update all parsers
:TSBufEnable highlight       " Enable highlighting
:TSBufDisable highlight      " Disable highlighting
:InspectTree                 " Show syntax tree
```

### Debugging (DAP) Commands
```vim
:DapInstall <debugger>       " Install debugger
:DapUninstall <debugger>     " Uninstall debugger
:DapContinue                 " Start/continue debugging
:DapToggleBreakpoint         " Toggle breakpoint
:DapStepOver                 " Step over
:DapStepInto                 " Step into
:DapStepOut                  " Step out
:DapTerminate                " Terminate debug session
```

## 🛡️ Security & Best Practices

### Environment Security
```bash
# Check installed packages
dpkg -l | grep -E "(zsh|tmux|neovim)"

# Verify checksums for critical downloads
sha256sum ~/.local/bin/nvim.appimage

# Regular security updates
sudo apt update && sudo apt upgrade
sudo apt autoremove
```

### Git Security Setup
```bash
# Configure Git with proper identity
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# Enable Git credential helper
git config --global credential.helper store

# Set up SSH keys for GitHub
ssh-keygen -t ed25519 -C "your.email@example.com"
```

### Backup Important Configurations
```bash
# Create backup script
#!/bin/bash
BACKUP_DIR="$HOME/dotfiles-backup-$(date +%Y%m%d)"
mkdir -p "$BACKUP_DIR"

cp ~/.zshrc "$BACKUP_DIR/"
cp ~/.tmux.conf "$BACKUP_DIR/"
cp -r ~/.config/nvim "$BACKUP_DIR/"
cp ~/.config/starship.toml "$BACKUP_DIR/"

echo "Backup created in $BACKUP_DIR"
```

## 🔧 Performance Optimization

### Zsh Performance Tuning
```bash
# Add to ~/.zshrc for faster startup
# Lazy load NVM
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

### Neovim Performance
```lua
-- Add to ~/.config/nvim/lua/plugins/performance.lua
return {
  {
    "AstroNvim/astrocore",
    opts = {
      options = {
        opt = {
          -- Improve performance
          updatetime = 250,
          timeoutlen = 300,
          -- Reduce memory usage
          maxmempattern = 2000,
          -- Faster completion
          completeopt = { "menu", "menuone", "noselect" },
        },
      },
    },
  },
}
```

### System Resource Monitoring
```bash
# Monitor system resources
htop                         # Interactive process viewer
iotop                        # I/O monitoring
nethogs                      # Network usage per process

# Disk space management
ncdu                         # NCurses disk usage
df -h                        # Disk space usage
du -sh ~/.config/nvim        # Neovim config size
```

## 📖 Learning Resources

### Neovim & AstroNvim
- [AstroNvim Documentation](https://docs.astronvim.com/)
- [Neovim User Manual](https://neovim.io/doc/user/)
- [Learn Vimscript the Hard Way](https://learnvimscriptthehardway.stevelosh.com/)
- [Lua in Neovim](https://github.com/nanotee/nvim-lua-guide)

### Tmux
- [Tmux Cheat Sheet](https://tmuxcheatsheet.com/)
- [The Tao of tmux](https://leanpub.com/the-tao-of-tmux)

### Zsh & Shell Scripting
- [Zsh Manual](https://zsh.sourceforge.io/Doc/)
- [Advanced Bash-Scripting Guide](https://tldp.org/LDP/abs/html/)

### Git & Development Workflow
- [Pro Git Book](https://git-scm.com/book)
- [GitHub Flow](https://guides.github.com/introduction/flow/)
- [Conventional Commits](https://www.conventionalcommits.org/)

## 🤝 Contributing

### Reporting Issues
1. Check existing issues first
2. Provide system information: `uname -a`, `lsb_release -a`
3. Include error messages and logs
4. Describe steps to reproduce

### Submitting Improvements
1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Test your changes thoroughly
4. Commit with descriptive messages
5. Submit a pull request

### Development Setup
```bash
# Clone for development
git clone https://github.com/your-username/System-Weaver.git
cd System-Weaver

# Test in a container
docker run -it ubuntu:22.04 bash
# Then run your modified script
```

---

**Happy coding with your supercharged development environment!** 🎉✨

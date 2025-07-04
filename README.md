# macOS One-Click Setup

A streamlined dotfiles and development environment setup specifically designed for macOS. This branch focuses on terminal productivity tools and modern development workflows using Homebrew.

## Features

- **🍺 Homebrew Integration**: Automated installation and package management
- **⚡ Ghostty Terminal**: GPU-accelerated terminal with custom configuration
- **🪟 yabai Window Manager**: Optional tiling window manager for automatic window management
- **🚀 Modern CLI Tools**: eza, zoxide, fzf, ripgrep, bat, and more
- **🎨 Beautiful Shell**: Zsh with Oh My Zsh, Starship prompt, and syntax highlighting
- **📱 tmux Setup**: Feature-rich multiplexer with plugins and Catppuccin theme
- **⚙️ LazyVim Configuration**: Modern Neovim setup with LSP and plugins
- **🔧 Smart Backup System**: Automatically backs up existing configurations
- **🎯 macOS Optimized**: Native integrations and macOS-specific configurations

## Quick Start

```bash
# Clone the repository
git clone -b macos https://github.com/yourusername/one-click-system-setup.git ~/.dotfiles-macos
cd ~/.dotfiles-macos

# Run the setup
./setup.sh
```

## What Gets Configured

### Core Development Environment
- **Terminal**: Ghostty with GPU acceleration, custom keybindings, and transparency
- **Shell**: Zsh with Oh My Zsh, Starship prompt, autosuggestions, and syntax highlighting
- **Multiplexer**: tmux with TPM, 10+ plugins, and optimized configuration
- **Editor**: LazyVim (Neovim) with automatic plugin installation and LSP setup
- **Version Control**: Git with sensible defaults and aliases

### Modern CLI Tools
- **File Management**: `eza` (better ls), `yazi` (terminal file manager)
- **Navigation**: `zoxide` (smart cd), `fzf` (fuzzy finder)
- **Text Processing**: `ripgrep` (better grep), `bat` (better cat), `fd` (better find)
- **System Monitoring**: `htop` (process viewer)
- **Development**: `lazygit` (Git TUI), `starship` (cross-shell prompt)

### Optional Applications
The setup includes an interactive installer for GUI applications:

#### Development Tools
- **Cursor AI**: AI-powered code editor
- **Postman**: API development platform
- **Visual Studio Code**: Microsoft's code editor

#### Productivity Apps
- **Obsidian**: Knowledge management
- **Slack**: Team communication
- **Notion**: All-in-one workspace

#### macOS Utilities
- **Rectangle**: Window management
- **Raycast**: Powerful launcher and productivity tool
- **Stats**: System monitor for menu bar

#### Browsers & Media
- **Firefox**: Open source browser
- **Google Chrome**: Google's browser
- **VLC**: Universal media player

## Installation Methods

### 1. Full Setup (Recommended)
```bash
./setup.sh
```
Installs all dotfiles, CLI tools, and optionally GUI applications.

### 2. Applications Only
```bash
./modules/applications/applications.sh
```
Interactive installer for GUI applications using Homebrew casks.

### 3. Individual Modules
```bash
# Install just terminal configuration
./modules/terminal/terminal.sh

# Install just Homebrew and CLI tools
./modules/homebrew/homebrew.sh

# Install just yabai window manager
./modules/window-manager/yabai.sh
```

## Application Installation Modes

### Interactive Mode (Recommended)
- Yes/No prompts for each application
- Smart defaults for recommended apps
- Visual feedback with ✓/✗ indicators

### Quick Presets
- **Essential** (5 apps): cursor, firefox, obsidian, rectangle, ghostty
- **Developer** (8 apps): Essential + chrome, postman, vscode
- **Productivity** (10 apps): Developer + slack, notion
- **Full Setup** (15 apps): Productivity + raycast, stats, figma, vlc, iterm2

### Legacy Mode
- Type application names directly
- Supports individual apps or categories

## Key Features

### 🖥️ Ghostty Terminal Configuration
- **GPU Acceleration**: Smooth performance and rendering
- **Custom Keybindings**: cmd+s prefix for splits and tabs (tmux-style)
- **Native macOS Integration**: Transparent titlebar, proper font rendering
- **Catppuccin Theme**: Beautiful, consistent color scheme
- **MesloLGS Nerd Font**: Icon support for modern CLI tools

### 🐚 Enhanced Shell Experience
- **Starship Prompt**: Fast, informative, and customizable
- **Intelligent Autosuggestions**: Based on history and completions
- **Syntax Highlighting**: Real-time command validation
- **Modern Aliases**: eza, bat, and other enhanced commands

### 🔧 tmux Configuration
- **Automated Plugin Installation**: No manual setup required
- **10+ Essential Plugins**: Sessions, clipboard, fuzzy finding, and more
- **Catppuccin Theme**: Consistent visual experience
- **Optimized Keybindings**: Ctrl+A prefix with logical layouts

### 🪟 yabai Window Manager (Optional)
- **Automatic Tiling**: BSP (Binary Space Partitioning) layout
- **Vim-style Navigation**: hyper + hjkl for window focus and movement
- **Multi-Space Workflow**: Navigate between desktop spaces with keyboard
- **Configurable Rules**: Specific apps can float or tile automatically
- **skhd Integration**: Powerful hotkey daemon for seamless control

### ⚡ Development Tools
- **LazyVim**: Modern Neovim configuration with sensible defaults
- **Mason**: Automatic LSP and tool installation
- **Git Integration**: Optimized workflows and aliases
- **Language Support**: Comprehensive LSP setup for multiple languages

## Directory Structure

```
~/.dotfiles-macos/
├── setup.sh                 # Main setup script
├── modules/                  # Individual configuration modules
│   ├── homebrew/            # Homebrew and package installation
│   ├── terminal/            # Ghostty terminal configuration
│   ├── window-manager/      # yabai tiling window manager
│   ├── shell/               # Zsh and shell setup
│   ├── tmux/                # tmux configuration and plugins
│   ├── neovim/              # LazyVim (Neovim) setup
│   ├── git/                 # Git configuration
│   ├── applications/        # GUI application installer
│   ├── scripts/             # User scripts and utilities
│   └── misc/                # Miscellaneous configurations
├── dotfiles/                # All dotfiles and configurations
│   ├── terminal/            # Ghostty config
│   ├── yabai/               # yabai window manager config
│   ├── skhd/                # skhd hotkey configuration
│   ├── zsh/                 # Zsh configuration
│   ├── tmux/                # tmux configuration
│   ├── nvim/                # Neovim configuration
│   ├── starship/            # Starship prompt config
│   └── git/                 # Git configuration
└── scripts/                 # Utility scripts
```

## Customization

### Terminal Themes
Ghostty supports 100+ built-in themes. List available themes:
```bash
ghostty +list-themes
```

Edit your Ghostty config:
```bash
vim ~/.config/ghostty/config
```

### Shell Prompt
Configure Starship prompt:
```bash
vim ~/.config/starship.toml
# or use the configuration wizard
p10k configure
```

### tmux Plugins
Add new plugins to `~/.tmux.conf`:
```bash
set -g @plugin 'plugin-name'
```
Then reload: `tmux source ~/.tmux.conf` and install: `prefix + I`

### yabai Window Manager
Configure yabai rules and behavior:
```bash
vim ~/.config/yabai/yabairc
```

Customize hotkeys:
```bash
vim ~/.config/skhd/skhdrc
```

Restart services after changes:
```bash
brew services restart yabai
brew services restart skhd
```

## Requirements

- **macOS**: Monterey (12.0) or later
- **Internet Connection**: For downloading Homebrew and packages
- **Terminal Access**: Command line access (Terminal.app or existing terminal)

## Migration from Linux Branch

This macOS branch is a streamlined version of the main Linux branch with key differences:

### Removed Components
- ❌ Hyprland window manager (Linux-specific)
- ❌ Waybar, Wofi, SwayNC (Wayland-specific)
- ❌ System package managers (pacman, apt)
- ❌ Display manager configuration
- ❌ Desktop entries and Linux-specific scripts

### Added Components
- ✅ Homebrew package management
- ✅ Ghostty terminal (replacing Kitty)
- ✅ macOS-specific utilities (Rectangle, Raycast)
- ✅ Native macOS integrations

## Troubleshooting

### Ghostty Terminal Issues
```bash
# If you see "unknown terminal type" errors
export TERM=xterm-256color
```

### Homebrew Issues
```bash
# Fix Homebrew PATH issues
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
source ~/.zshrc
```

### Plugin Installation
```bash
# Manually install tmux plugins if needed
prefix + I  # (Ctrl+A then I)

# Reinstall Oh My Zsh plugins
rm -rf ~/.oh-my-zsh/custom/plugins/*
./modules/shell/zsh.sh
```

## Comparison with Linux Version

| Feature | Linux Branch | macOS Branch |
|---------|-------------|--------------|
| Package Manager | pacman/apt | Homebrew |
| Terminal | Kitty | Ghostty |
| Window Manager | Hyprland | yabai + Rectangle |
| Launcher | Wofi | Raycast |
| File Manager | Thunar | Finder + Path Finder |
| System Monitor | Various | Stats |
| Installation | Multi-OS detection | macOS-focused |

## Contributing

This macOS branch maintains compatibility with the main branch's dotfiles while optimizing for macOS workflows. When contributing:

1. Ensure changes work on both Intel and Apple Silicon Macs
2. Use Homebrew for package management
3. Test with both fresh installs and updates
4. Follow the existing modular structure

## Support

For issues specific to this macOS branch, please open an issue with:
- macOS version
- Hardware (Intel/Apple Silicon)
- Terminal emulator used
- Error messages or logs

---

**Enjoy your streamlined macOS development environment! 🚀** 
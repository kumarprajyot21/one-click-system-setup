#!/bin/bash

# macOS One-Click Setup
# Automated dotfiles and development environment setup for macOS

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
LOG_FILE="$SCRIPT_DIR/setup.log"

# Logging function
log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1" | tee -a "$LOG_FILE"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1" | tee -a "$LOG_FILE"
    exit 1
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1" | tee -a "$LOG_FILE"
}

info() {
    echo -e "${BLUE}[INFO]${NC} $1" | tee -a "$LOG_FILE"
}

# Check if running on macOS
check_macos() {
    if [[ "$(uname)" != "Darwin" ]]; then
        error "This script is designed for macOS only. For Linux, use the main branch."
    fi
}

# Check if running as root
check_root() {
    if [[ $EUID -eq 0 ]]; then
        error "This script should not be run as root. Please run as a regular user."
    fi
}

# Create backup directory
create_backup() {
    if [[ ! -d "$BACKUP_DIR" ]]; then
        mkdir -p "$BACKUP_DIR"
        log "Created backup directory: $BACKUP_DIR"
    fi
}

# Setup user configurations
setup_user_configs() {
    log "Setting up user configurations..."
    
    # Create .config directory if it doesn't exist
    mkdir -p "$HOME/.config"
    
    # Setup modules in order for macOS
    local modules=(
        "homebrew/homebrew.sh"    # Install Homebrew and essential tools
        "shell/zsh.sh"            # Zsh configuration with Oh My Zsh
        "git/git.sh"              # Git configuration
        "tmux/tmux.sh"            # tmux configuration and plugins
        "neovim/lazyvim.sh"       # LazyVim (Neovim) setup
        "terminal/terminal.sh"    # Ghostty terminal configuration
        "scripts/user-scripts.sh" # User scripts and utilities
        "misc/misc.sh"            # Miscellaneous configurations
    )
    
    for module in "${modules[@]}"; do
        if [[ -f "$SCRIPT_DIR/modules/$module" ]]; then
            log "Running module: $module"
            bash "$SCRIPT_DIR/modules/$module" || warning "Module $module completed with warnings"
        else
            warning "Module not found: $module"
        fi
    done
}

# Optional yabai window manager installation
install_yabai() {
    echo -e "\n${YELLOW}🪟 Window Manager Installation${NC}"
    echo "Would you like to install yabai tiling window manager?"
    echo "This provides automatic window tiling similar to Hyprland on Linux."
    echo "Note: Requires Accessibility permissions and may need SIP configuration."
    echo
    
    while true; do
        read -p "Install yabai window manager? [y/N]: " install_wm
        case "$install_wm" in
            [Yy]*)
                log "Starting yabai window manager installation..."
                bash "$SCRIPT_DIR/modules/window-manager/yabai.sh"
                break
                ;;
            [Nn]*|"")
                info "Skipping yabai installation. You can run it later with:"
                info "  bash $SCRIPT_DIR/modules/window-manager/yabai.sh"
                break
                ;;
            *)
                echo -e "${YELLOW}Please enter y or n${NC}"
                ;;
        esac
    done
}

# Optional application installation
install_applications() {
    echo -e "\n${YELLOW}📱 Application Installation${NC}"
    echo "Would you like to install applications using Homebrew?"
    echo "This includes GUI apps like Cursor, Firefox, Obsidian, Rectangle, etc."
    echo
    
    while true; do
        read -p "Install applications? [y/N]: " install_apps
        case "$install_apps" in
            [Yy]*)
                log "Starting application installation..."
                bash "$SCRIPT_DIR/modules/applications/applications.sh"
                break
                ;;
            [Nn]*|"")
                info "Skipping application installation. You can run it later with:"
                info "  bash $SCRIPT_DIR/modules/applications/applications.sh"
                break
                ;;
            *)
                echo -e "${YELLOW}Please enter y or n${NC}"
                ;;
        esac
    done
}

# Show completion message with next steps
show_completion_message() {
    echo -e "\n${GREEN}🎉 macOS Setup Complete!${NC}"
    echo
    echo -e "${BLUE}What was installed:${NC}"
    echo "  ✅ Homebrew package manager"
    echo "  ✅ Essential CLI tools (eza, zoxide, fzf, ripgrep, etc.)"
    echo "  ✅ Zsh with Oh My Zsh, plugins, and Starship prompt"
    echo "  ✅ tmux with plugins and Catppuccin theme"
    echo "  ✅ LazyVim (Neovim) configuration"
    echo "  ✅ Ghostty terminal with optimized config"
    echo "  ✅ Git configuration"
    echo "  ✅ User scripts and utilities"
    echo "  🪟 yabai window manager (optional)"
    echo
    echo -e "${YELLOW}📝 Next Steps:${NC}"
    echo "  1. Restart your terminal or run: source ~/.zshrc"
    echo "  2. Open Ghostty terminal for the best experience"
    echo "  3. Start tmux with: tmux"
    echo "  4. Open Neovim with: nvim (LazyVim will install plugins)"
    echo "  5. Try modern CLI tools:"
    echo "     • ls → eza"
    echo "     • cd → z (zoxide)"
    echo "     • cat → bat"
    echo "     • find → fd"
    echo "     • grep → rg (ripgrep)"
    echo
    echo -e "${CYAN}💡 Pro Tips:${NC}"
    echo "  • Use 'p10k configure' to customize your Starship prompt"
    echo "  • Press Ctrl+A in tmux (prefix key) for tmux commands"
    echo "  • Use cmd+s as prefix in Ghostty for splits and tabs"
    echo "  • yabai hotkeys use hyper key (cmd+ctrl+shift+alt) + hjkl for navigation"
    echo "  • Run applications installer anytime: ./modules/applications/applications.sh"
    echo "  • Run yabai installer anytime: ./modules/window-manager/yabai.sh"
    echo
    echo -e "${GREEN}Enjoy your new macOS development environment! 🚀${NC}"
}

# Main setup function
main() {
    echo -e "${BLUE}"
    echo "╔══════════════════════════════════════╗"
    echo "║       macOS One-Click Setup          ║"
    echo "║   Development Environment Installer  ║"
    echo "╚══════════════════════════════════════╝"
    echo -e "${NC}"
    
    check_macos
    check_root
    create_backup
    
    log "Starting macOS development environment setup..."
    
    # Main configuration setup
    setup_user_configs
    
    # Optional yabai window manager installation
    install_yabai
    
    # Optional application installation
    install_applications
    
    # Show completion message
    show_completion_message
    
    log "Setup completed successfully!"
}

# Run main function
main "$@" 
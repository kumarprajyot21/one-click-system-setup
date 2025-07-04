#!/bin/bash

# Homebrew package manager setup for macOS

set -euo pipefail

source "$(dirname "$0")/../../scripts/utils.sh"

log "Setting up Homebrew package manager..."

# Check if we're on macOS
if [[ "$(uname)" != "Darwin" ]]; then
    error "This script is only for macOS systems"
fi

# Install Homebrew if not present
if ! command_exists brew; then
    log "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for current session
    if [[ -f "/opt/homebrew/bin/brew" ]]; then
        # Apple Silicon Mac
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -f "/usr/local/bin/brew" ]]; then
        # Intel Mac
        eval "$(/usr/local/bin/brew shellenv)"
    fi
else
    log "Homebrew is already installed"
fi

# Update Homebrew
log "Updating Homebrew..."
brew update

# Install essential CLI tools
log "Installing essential CLI tools..."

# Modern replacements for common commands
essential_tools=(
    "eza"           # Modern replacement for ls
    "zoxide"        # Smarter cd command
    "yazi"          # Terminal file manager
    "fzf"           # Fuzzy finder
    "fd"            # Modern replacement for find
    "ripgrep"       # Modern replacement for grep
    "bat"           # Modern replacement for cat
    "htop"          # Process viewer
    "git"           # Version control
    "starship"      # Cross-shell prompt
    "tmux"          # Terminal multiplexer
    "neovim"        # Modern vim
    "lazygit"       # Git TUI
)

for tool in "${essential_tools[@]}"; do
    if ! command_exists "$tool"; then
        log "Installing $tool..."
        brew install "$tool" || warning "Failed to install $tool"
    else
        info "$tool is already installed"
    fi
done

# Install Nerd Font for terminal icons
log "Installing MesloLGS Nerd Font..."
brew install --cask font-meslo-lg-nerd-font || warning "Failed to install Nerd Font"

# Install Ghostty terminal
log "Installing Ghostty terminal..."
brew install --cask ghostty || warning "Failed to install Ghostty"

log "Homebrew setup completed!"
log ""
log "🍺 Homebrew Setup Complete!"
log "Installed essential CLI tools:"
log "  • eza (modern ls)"
log "  • zoxide (smart cd)"
log "  • yazi (file manager)"
log "  • fzf (fuzzy finder)"
log "  • fd, ripgrep, bat (modern find, grep, cat)"
log "  • htop (process viewer)"
log "  • git, lazygit (version control)"
log "  • starship (shell prompt)"
log "  • tmux (terminal multiplexer)"
log "  • neovim (editor)"
log "  • Ghostty (terminal emulator)"
log "  • MesloLGS Nerd Font" 
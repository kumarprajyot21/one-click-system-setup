#!/bin/bash

# User scripts setup for macOS

set -euo pipefail

source "$(dirname "$0")/../../scripts/utils.sh"

log "Setting up user scripts..."

# Create scripts directory
ensure_dir "$HOME/scripts"

# Monitor layout switcher - replaced with macOS native display preferences
# Note: macOS users can use System Preferences > Displays or third-party tools like DisplayMenu

# Zoxide + Neovim integration script
if [[ -f "$REPO_ROOT/dotfiles/scripts/zoxide_openfiles_nvim.sh" ]]; then
    link_dotfile "$REPO_ROOT/dotfiles/scripts/zoxide_openfiles_nvim.sh" "$HOME/scripts/zoxide_openfiles_nvim.sh"
    chmod +x "$HOME/scripts/zoxide_openfiles_nvim.sh"
fi

# Simple zoom/project navigation script  
if [[ -f "$REPO_ROOT/dotfiles/scripts/zoom.sh" ]]; then
    link_dotfile "$REPO_ROOT/dotfiles/scripts/zoom.sh" "$HOME/scripts/zoom.sh"
    chmod +x "$HOME/scripts/zoom.sh"
fi

# Zoom meeting launcher script
if [[ -f "$REPO_ROOT/dotfiles/scripts/zoom-meeting.sh" ]]; then
    link_dotfile "$REPO_ROOT/dotfiles/scripts/zoom-meeting.sh" "$HOME/scripts/zoom-meeting.sh"
    chmod +x "$HOME/scripts/zoom-meeting.sh"
fi

# Create symbolic links to make scripts available in PATH
ensure_dir "$HOME/.local/bin"

# Link scripts to .local/bin for PATH access
if [[ -f "$HOME/scripts/zoxide_openfiles_nvim.sh" ]]; then
    ln -sf "$HOME/scripts/zoxide_openfiles_nvim.sh" "$HOME/.local/bin/nzo"
    info "Created symlink: nzo -> zoxide_openfiles_nvim.sh"
fi

if [[ -f "$HOME/scripts/zoom.sh" ]]; then
    ln -sf "$HOME/scripts/zoom.sh" "$HOME/.local/bin/zoom-nav"
    info "Created symlink: zoom-nav -> zoom.sh"
fi

if [[ -f "$HOME/scripts/zoom-meeting.sh" ]]; then
    ln -sf "$HOME/scripts/zoom-meeting.sh" "$HOME/.local/bin/zoom-meeting"
    info "Created symlink: zoom-meeting -> zoom-meeting.sh"
fi

# Add ~/.local/bin to PATH in shell config if not already present
if [[ -f "$HOME/.zshrc" ]] && ! grep -q 'PATH.*\.local/bin' "$HOME/.zshrc"; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.zshrc"
    info "Added ~/.local/bin to PATH in .zshrc"
fi

log "User scripts setup completed!"
log ""
log "📁 Available Scripts:"
if [[ -f "$HOME/scripts/zoxide_openfiles_nvim.sh" ]]; then
    log "  nzo - Smart directory navigation with Neovim integration"
fi
if [[ -f "$HOME/scripts/zoom.sh" ]]; then
    log "  zoom-nav - Quick project/directory navigation"
fi
if [[ -f "$HOME/scripts/zoom-meeting.sh" ]]; then
    log "  zoom-meeting - Launch Zoom meetings from shortcuts"
fi
log ""
log "💡 macOS Display Management:"
log "  • Use System Preferences > Displays for monitor configuration"
log "  • Consider installing Rectangle for window management: brew install --cask rectangle"
log "  • DisplayMenu is a great tool for quick display switching: brew install --cask displaymenu" 
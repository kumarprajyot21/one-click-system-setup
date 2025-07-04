#!/bin/bash

# Miscellaneous configurations for macOS

set -euo pipefail

source "$(dirname "$0")/../../scripts/utils.sh"

log "Setting up miscellaneous configurations..."

# Create necessary directories
ensure_dir "$HOME/.config"
ensure_dir "$HOME/Pictures/Screenshots"

# Link other misc configurations if they exist
if [[ -d "$REPO_ROOT/dotfiles/misc" ]]; then
    for config in "$REPO_ROOT/dotfiles/misc"/*; do
        if [[ -f "$config" ]]; then
            local filename=$(basename "$config")
            link_dotfile "$config" "$HOME/.config/$filename"
        fi
    done
fi

# macOS-specific configurations
log "Setting up macOS-specific configurations..."

# Create screenshot directory with proper permissions
if [[ ! -d "$HOME/Pictures/Screenshots" ]]; then
    mkdir -p "$HOME/Pictures/Screenshots"
    info "Created screenshots directory: ~/Pictures/Screenshots"
fi

# macOS screenshot helper function (can be added to shell functions)
create_screenshot_functions() {
    local functions_file="$HOME/.config/functions.zsh"
    
    cat > "$functions_file" << 'EOF'
# macOS Screenshot Functions
# Usage in terminal after sourcing this file

# Screenshot entire screen
screenshot_full() {
    local filename="$HOME/Pictures/Screenshots/screenshot-$(date +%Y%m%d-%H%M%S).png"
    screencapture "$filename"
    echo "Screenshot saved: $filename"
}

# Screenshot selected area
screenshot_area() {
    local filename="$HOME/Pictures/Screenshots/screenshot-$(date +%Y%m%d-%H%M%S).png"
    screencapture -s "$filename"
    echo "Screenshot saved: $filename"
}

# Screenshot specific window (interactive selection)
screenshot_window() {
    local filename="$HOME/Pictures/Screenshots/screenshot-$(date +%Y%m%d-%H%M%S).png"
    screencapture -w "$filename"
    echo "Screenshot saved: $filename"
}

# macOS system shortcuts (for reference):
# Cmd+Shift+3: Full screen screenshot
# Cmd+Shift+4: Select area screenshot  
# Cmd+Shift+4+Space: Window screenshot
# Cmd+Shift+5: Screenshot tool with options
EOF

    info "Created screenshot functions in ~/.config/functions.zsh"
    info "Source it in your .zshrc with: source ~/.config/functions.zsh"
}

create_screenshot_functions

# macOS system preferences helper
create_system_helpers() {
    local helpers_file="$HOME/.config/macos-helpers.zsh"
    
    cat > "$helpers_file" << 'EOF'
# macOS System Helpers
# Useful functions for macOS system management

# Quick system preferences
sys_prefs() {
    case "$1" in
        "displays"|"display")
            open "/System/Library/PreferencePanes/Displays.prefPane"
            ;;
        "sound"|"audio")
            open "/System/Library/PreferencePanes/Sound.prefPane"
            ;;
        "network")
            open "/System/Library/PreferencePanes/Network.prefPane"
            ;;
        "bluetooth")
            open "/System/Library/PreferencePanes/Bluetooth.prefPane"
            ;;
        "users")
            open "/System/Library/PreferencePanes/Accounts.prefPane"
            ;;
        "security")
            open "/System/Library/PreferencePanes/Security.prefPane"
            ;;
        *)
            echo "Usage: sys_prefs [displays|sound|network|bluetooth|users|security]"
            echo "Or just run: open '/System/Library/PreferencePanes/'"
            ;;
    esac
}

# Finder helpers
finder_show_hidden() {
    defaults write com.apple.finder AppleShowAllFiles YES
    killall Finder
    echo "Hidden files are now visible in Finder"
}

finder_hide_hidden() {
    defaults write com.apple.finder AppleShowAllFiles NO
    killall Finder
    echo "Hidden files are now hidden in Finder"
}

# Dock helpers
dock_autohide_on() {
    defaults write com.apple.dock autohide -bool true
    killall Dock
    echo "Dock auto-hide enabled"
}

dock_autohide_off() {
    defaults write com.apple.dock autohide -bool false
    killall Dock
    echo "Dock auto-hide disabled"
}
EOF

    info "Created system helpers in ~/.config/macos-helpers.zsh"
    info "Source it in your .zshrc with: source ~/.config/macos-helpers.zsh"
}

create_system_helpers

log "Miscellaneous setup completed!"
log ""
log "📋 Created helper functions:"
log "  • Screenshot functions: ~/.config/functions.zsh"
log "  • System helpers: ~/.config/macos-helpers.zsh"
log ""
log "💡 To use these functions, add to your ~/.zshrc:"
log "  source ~/.config/functions.zsh"
log "  source ~/.config/macos-helpers.zsh"
log ""
log "🖼️  macOS Screenshot Shortcuts:"
log "  • Cmd+Shift+3: Full screen"
log "  • Cmd+Shift+4: Select area"
log "  • Cmd+Shift+4+Space: Window"
log "  • Cmd+Shift+5: Screenshot tool" 
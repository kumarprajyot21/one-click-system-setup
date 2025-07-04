#!/bin/bash

# yabai tiling window manager setup for macOS

set -euo pipefail

source "$(dirname "$0")/../../scripts/utils.sh"

log "Setting up yabai tiling window manager..."

# Check if we're on macOS
if [[ "$(uname)" != "Darwin" ]]; then
    error "This script is only for macOS systems"
fi

# Check if Homebrew is installed
if ! command_exists brew; then
    error "Homebrew is required but not installed. Please run the homebrew module first."
fi

# Install yabai and skhd
log "Installing yabai and skhd..."
brew install koekeishiya/formulae/yabai || warning "Failed to install yabai"
brew install koekeishiya/formulae/skhd || warning "Failed to install skhd"

# Create config directories
ensure_dir "$HOME/.config/yabai"
ensure_dir "$HOME/.config/skhd"

# Create yabai configuration
log "Creating yabai configuration..."
cat > "$REPO_ROOT/dotfiles/yabai/yabairc" << 'EOF'
#!/usr/bin/env sh

# yabai configuration for macOS tiling window manager

# Global settings
yabai -m config mouse_follows_focus          off
yabai -m config focus_follows_mouse          off
yabai -m config window_origin_display        default
yabai -m config window_placement             second_child
yabai -m config window_topmost               off
yabai -m config window_shadow                on
yabai -m config window_animation_duration    0.0
yabai -m config window_opacity_duration      0.0
yabai -m config active_window_opacity        1.0
yabai -m config normal_window_opacity        0.90
yabai -m config window_opacity               off
yabai -m config insert_feedback_color        0xffd75f5f
yabai -m config split_ratio                  0.50
yabai -m config split_type                   auto
yabai -m config auto_balance                 off
yabai -m config top_padding                  10
yabai -m config bottom_padding               10
yabai -m config left_padding                 10
yabai -m config right_padding                10
yabai -m config window_gap                   10

# Layout settings
yabai -m config layout                       bsp
yabai -m config mouse_modifier               fn
yabai -m config mouse_action1                move
yabai -m config mouse_action2                resize
yabai -m config mouse_drop_action            swap

# Rules for specific applications
yabai -m rule --add app="^System Preferences$" manage=off
yabai -m rule --add app="^Archive Utility$" manage=off
yabai -m rule --add app="^Wally$" manage=off
yabai -m rule --add app="^Pika$" manage=off
yabai -m rule --add app="^balenaEtcher$" manage=off
yabai -m rule --add app="^Creative Cloud$" manage=off
yabai -m rule --add app="^Logi Options$" manage=off
yabai -m rule --add app="^PrintShop$" manage=off
yabai -m rule --add app="^System Information$" manage=off
yabai -m rule --add app="^Activity Monitor$" manage=off
yabai -m rule --add app="^Finder$" manage=off
yabai -m rule --add app="^Calculator$" manage=off
yabai -m rule --add app="^Digital Color Meter$" manage=off
yabai -m rule --add app="^Dictionary$" manage=off
yabai -m rule --add app="^Software Update$" manage=off
yabai -m rule --add app="^Disk Utility$" manage=off
yabai -m rule --add app="^System Settings$" manage=off
yabai -m rule --add app="^AppShelf$" manage=off
yabai -m rule --add app="^BRAW Toolbox$" manage=off

# Disable for dialogs and pop-ups
yabai -m rule --add title="^(Opening).*$" manage=off
yabai -m rule --add title="^Preferences$" manage=off

echo "yabai configuration loaded.."
EOF

# Create skhd configuration for hotkeys
log "Creating skhd hotkey configuration..."
cat > "$REPO_ROOT/dotfiles/skhd/skhdrc" << 'EOF'
# skhd hotkey configuration for yabai window manager

# Window focus (hyper = cmd + ctrl + shift + alt)
hyper - h : yabai -m window --focus west
hyper - j : yabai -m window --focus south
hyper - k : yabai -m window --focus north
hyper - l : yabai -m window --focus east

# Window movement (move windows in current workspace)
shift + hyper - h : yabai -m window --warp west
shift + hyper - j : yabai -m window --warp south
shift + hyper - k : yabai -m window --warp north
shift + hyper - l : yabai -m window --warp east

# Window resize
ctrl + hyper - h : yabai -m window --resize left:-50:0; \
                   yabai -m window --resize right:-50:0
ctrl + hyper - j : yabai -m window --resize bottom:0:50; \
                   yabai -m window --resize top:0:50
ctrl + hyper - k : yabai -m window --resize top:0:-50; \
                   yabai -m window --resize bottom:0:-50
ctrl + hyper - l : yabai -m window --resize right:50:0; \
                   yabai -m window --resize left:50:0

# Equalize size of windows
ctrl + hyper - e : yabai -m space --balance

# Enable / Disable gaps in current workspace
ctrl + hyper - g : yabai -m space --toggle padding; yabai -m space --toggle gap

# Rotate windows clockwise and anticlockwise
hyper - r : yabai -m space --rotate 270
shift + hyper - r : yabai -m space --rotate 90

# Rotate on X and Y Axis
shift + hyper - x : yabai -m space --mirror x-axis
shift + hyper - y : yabai -m space --mirror y-axis

# Set insertion point for focused container
shift + ctrl + hyper - h : yabai -m window --insert west
shift + ctrl + hyper - j : yabai -m window --insert south
shift + ctrl + hyper - k : yabai -m window --insert north
shift + ctrl + hyper - l : yabai -m window --insert east

# Float / Unfloat window
shift + hyper - space : yabai -m window --toggle float; \
                        yabai -m window --toggle border

# Make window zoom to fullscreen
shift + hyper - f : yabai -m window --toggle zoom-fullscreen

# Make window zoom to parent node
hyper - f : yabai -m window --toggle zoom-parent

# Toggle window split type
hyper - e : yabai -m window --toggle split

# Space Navigation (four spaces per display): cmd + [1-4]
cmd - 1 : yabai -m space --focus 1
cmd - 2 : yabai -m space --focus 2
cmd - 3 : yabai -m space --focus 3
cmd - 4 : yabai -m space --focus 4

# Move window to space and follow focus
shift + cmd - 1 : yabai -m window --space 1; yabai -m space --focus 1
shift + cmd - 2 : yabai -m window --space 2; yabai -m space --focus 2
shift + cmd - 3 : yabai -m window --space 3; yabai -m space --focus 3
shift + cmd - 4 : yabai -m window --space 4; yabai -m space --focus 4

# Application launchers using cmd + shift combinations
shift + cmd - return : open -na /Applications/Ghostty.app
shift + cmd - b : open -na "/Applications/Firefox.app"
shift + cmd - c : open -na "/Applications/Google Chrome.app"
shift + cmd - f : open -na /Applications/Finder.app

# Restart yabai
ctrl + shift + cmd - r : launchctl kickstart -k "gui/${UID}/homebrew.mxcl.yabai"
EOF

# Create directories and link configs
ensure_dir "$REPO_ROOT/dotfiles/yabai"
ensure_dir "$REPO_ROOT/dotfiles/skhd"

# Link configuration files
link_dotfile "$REPO_ROOT/dotfiles/yabai/yabairc" "$HOME/.config/yabai/yabairc"
link_dotfile "$REPO_ROOT/dotfiles/skhd/skhdrc" "$HOME/.config/skhd/skhdrc"

# Make yabai config executable
chmod +x "$HOME/.config/yabai/yabairc"

# Start services (optional - user can do this manually)
log "Setting up yabai and skhd services..."
info "To start yabai and skhd, run:"
info "  brew services start yabai"
info "  brew services start skhd"
info ""
info "⚠️  Important Setup Steps:"
info "1. Grant Accessibility permissions to skhd in System Preferences > Security & Privacy > Privacy > Accessibility"
info "2. For advanced features, you may need to disable SIP (System Integrity Protection)"
info "3. Restart your computer after initial setup"

log "yabai window manager setup completed!"
log ""
log "🪟 yabai Window Manager Features:"
log "  • Automatic window tiling (BSP layout)"
log "  • Vim-style window navigation (hyper + hjkl)"
log "  • Window resizing and rotation"
log "  • Multi-space workflow"
log "  • Float/tile toggle for specific apps"
log ""
log "⌨️  Key Bindings (hyper = cmd + ctrl + shift + alt):"
log "  • hyper + hjkl: Navigate windows"
log "  • shift + hyper + hjkl: Move windows"
log "  • ctrl + hyper + hjkl: Resize windows"
log "  • shift + hyper + space: Toggle float"
log "  • shift + hyper + f: Fullscreen"
log "  • cmd + 1-4: Switch spaces"
log "  • shift + cmd + 1-4: Move window to space"
log ""
log "🚀 Quick Start:"
log "  1. Grant Accessibility permissions to skhd"
log "  2. Run: brew services start yabai && brew services start skhd"
log "  3. Enjoy automatic window tiling!" 
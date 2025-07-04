#!/bin/bash

# Simple zoom script for macOS
# Works with any terminal multiplexer or application

# Navigate to the last directory
zoxide_openfiles_nvim() {
    if command -v zoxide >/dev/null 2>&1 && command -v fzf >/dev/null 2>&1; then
        # Use zoxide and fzf to find and open a directory
        local selected_dir
        selected_dir=$(zoxide query -l | fzf --prompt="Select directory: " --height=20 --reverse)
        
        if [[ -n "$selected_dir" ]]; then
            cd "$selected_dir" || return 1
            
            # Open nvim if available
            if command -v nvim >/dev/null 2>&1; then
                nvim .
            else
                echo "Opened directory: $selected_dir"
            fi
        fi
    else
        echo "This script requires zoxide and fzf to be installed"
        echo "Install with: brew install zoxide fzf"
    fi
}

# Check if running as a script or being sourced
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    # Called as script
    zoxide_openfiles_nvim
fi 
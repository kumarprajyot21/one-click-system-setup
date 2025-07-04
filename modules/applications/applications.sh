#!/bin/bash

# Application installation module for macOS with Homebrew

set -euo pipefail

# Get the directory of this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

source "$REPO_ROOT/scripts/utils.sh"

# Colors for output (in case they're not defined in utils.sh)
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Check if we're on macOS
if [[ "$(uname)" != "Darwin" ]]; then
    error "This script is only for macOS systems"
fi

# Check if Homebrew is installed
if ! command_exists brew; then
    error "Homebrew is required but not installed. Please run the homebrew module first."
fi

# Define macOS application categories and their apps
declare -A APPLICATIONS

# Development Tools
APPLICATIONS["dev_cursor"]="Cursor AI|https://cursor.sh/|cursor|AI-powered code editor"
APPLICATIONS["dev_postman"]="Postman|https://www.postman.com/|postman|API development platform"
APPLICATIONS["dev_vscode"]="Visual Studio Code|https://code.visualstudio.com/|visual-studio-code|Microsoft's code editor"

# Browsers
APPLICATIONS["browser_firefox"]="Firefox|https://www.mozilla.org/firefox/|firefox|Open source browser"
APPLICATIONS["browser_chrome"]="Google Chrome|https://www.google.com/chrome/|google-chrome|Google's browser"
APPLICATIONS["browser_safari"]="Safari Technology Preview|https://developer.apple.com/safari/|safari-technology-preview|Apple's experimental browser"

# Productivity
APPLICATIONS["prod_obsidian"]="Obsidian|https://obsidian.md/|obsidian|Knowledge management"
APPLICATIONS["prod_slack"]="Slack|https://slack.com/|slack|Team communication"
APPLICATIONS["prod_notion"]="Notion|https://notion.so/|notion|All-in-one workspace"

# macOS Utilities
APPLICATIONS["util_rectangle"]="Rectangle|https://rectangleapp.com/|rectangle|Window management"
APPLICATIONS["util_raycast"]="Raycast|https://raycast.com/|raycast|Powerful launcher"
APPLICATIONS["util_finder"]="Path Finder|https://cocoatech.io/|path-finder|Enhanced file manager"
APPLICATIONS["util_stats"]="Stats|https://github.com/exelban/stats|stats|System monitor"

# Terminal & Development
APPLICATIONS["term_ghostty"]="Ghostty|https://ghostty.org/|ghostty|GPU-accelerated terminal"
APPLICATIONS["term_iterm2"]="iTerm2|https://iterm2.com/|iterm2|Feature-rich terminal"

# Design & Media
APPLICATIONS["design_figma"]="Figma|https://www.figma.com/|figma|Design tool"
APPLICATIONS["media_vlc"]="VLC|https://www.videolan.org/vlc/|vlc|Media player"

# Function to install Homebrew cask application
install_cask_app() {
    local cask_name="$1"
    local app_name="$2"
    
    log "Installing $app_name..."
    if brew install --cask "$cask_name" 2>/dev/null; then
        info "✅ Successfully installed $app_name"
        return 0
    else
        warning "❌ Failed to install $app_name"
        return 1
    fi
}

# Function to display applications by category
show_applications() {
    local category="$1"
    local title="$2"
    
    echo -e "\n${BLUE}=== $title ===${NC}"
    for key in "${!APPLICATIONS[@]}"; do
        if [[ "$key" == "${category}_"* ]]; then
            IFS='|' read -r name url cask desc <<< "${APPLICATIONS[$key]}"
            local display_key="${key#${category}_}"
            printf "  %-15s %s - %s\n" "$display_key" "$name" "$desc"
        fi
    done
}

# Function to get user selections
get_user_selections() {
    local -n result_array=$1
    local user_selections=()
    
    echo -e "\n${CYAN}Application Selection Mode:${NC}"
    echo "  1) Interactive mode - Yes/No prompts for each application (recommended)"
    echo "  2) Quick presets - Choose from predefined sets"
    echo "  3) Legacy mode - Type application names"
    echo
    
    local selection_mode
    while true; do
        read -p "Choose selection mode [1/2/3]: " mode_choice
        case "$mode_choice" in
            1)
                selection_mode="interactive"
                break
                ;;
            2)
                selection_mode="presets"
                break
                ;;
            3)
                selection_mode="legacy"
                break
                ;;
            *)
                echo -e "${YELLOW}Please enter 1, 2, or 3${NC}"
                ;;
        esac
    done
    
    case "$selection_mode" in
        "interactive")
            get_interactive_selections user_selections
            ;;
        "presets")
            get_preset_selections user_selections
            ;;
        "legacy")
            get_legacy_selections user_selections
            ;;
    esac
    
    result_array=("${user_selections[@]}")
}

# Interactive yes/no selection for each app
get_interactive_selections() {
    local -n interactive_selections=$1
    
    echo -e "\n${YELLOW}📱 Interactive Application Selection${NC}"
    echo -e "${CYAN}For each application, press:${NC}"
    echo -e "  ${GREEN}y/Y${NC} = Yes, install this"
    echo -e "  ${RED}n/N${NC} = No, skip this"
    echo -e "  ${BLUE}Enter${NC} = Use recommended default"
    echo -e "  ${YELLOW}q${NC} = Quit selection and use current choices"
    echo
    
    # Define recommended apps for macOS
    local recommended_apps=(
        "dev_cursor" "browser_firefox" "browser_chrome" 
        "prod_obsidian" "util_rectangle" "util_raycast" "term_ghostty"
    )
    
    # Process each category
    process_category "Development Tools" "dev" interactive_selections recommended_apps
    process_category "Browsers" "browser" interactive_selections recommended_apps
    process_category "Productivity" "prod" interactive_selections recommended_apps
    process_category "macOS Utilities" "util" interactive_selections recommended_apps
    process_category "Terminal & Development" "term" interactive_selections recommended_apps
    process_category "Design & Media" "design" interactive_selections recommended_apps
    process_category "Media" "media" interactive_selections recommended_apps
    
    if [[ ${#interactive_selections[@]} -eq 0 ]]; then
        echo -e "\n${YELLOW}No applications selected. Would you like to install the essential preset instead?${NC}"
        read -p "Install essential apps (cursor, firefox, obsidian, rectangle, ghostty)? [y/N]: " install_essential
        if [[ "$install_essential" =~ ^[Yy]$ ]]; then
            interactive_selections+=(
                "dev_cursor" "browser_firefox" "prod_obsidian" 
                "util_rectangle" "term_ghostty"
            )
        fi
    fi
}

# Process each category with yes/no prompts
process_category() {
    local category_title="$1"
    local category_prefix="$2"
    local -n category_selections=$3
    local -n recommended=$4
    
    echo -e "\n${BLUE}=== $category_title ===${NC}"
    
    # Get apps in this category
    local category_apps=()
    for key in "${!APPLICATIONS[@]}"; do
        if [[ "$key" == "${category_prefix}_"* ]]; then
            category_apps+=("$key")
        fi
    done
    
    # Sort apps for consistent order
    IFS=$'\n' category_apps=($(sort <<<"${category_apps[*]}"))
    
    for app_key in "${category_apps[@]}"; do
        IFS='|' read -r name url cask desc <<< "${APPLICATIONS[$app_key]}"
        
        # Check if this app is recommended
        local is_recommended=false
        for rec_app in "${recommended[@]}"; do
            if [[ "$app_key" == "$rec_app" ]]; then
                is_recommended=true
                break
            fi
        done
        
        # Show the prompt with cleaner formatting
        echo -e "\n${CYAN}$name${NC} - $desc"
        
        local prompt_text="Install $name? "
        if [[ "$is_recommended" == true ]]; then
            prompt_text+="[Y/n] "
        else
            prompt_text+="[y/N] "
        fi
        
        while true; do
            read -p "$prompt_text" choice
            
            case "$choice" in
                [Yy]*)
                    category_selections+=("$app_key")
                    echo -e "  ${GREEN}✓${NC} Will install $name"
                    break
                    ;;
                [Nn]*)
                    echo -e "  ${RED}✗${NC} Skipping $name"
                    break
                    ;;
                [Qq]*)
                    echo -e "\n${YELLOW}Stopping selection...${NC}"
                    return
                    ;;
                "")
                    if [[ "$is_recommended" == true ]]; then
                        category_selections+=("$app_key")
                        echo -e "  ${GREEN}✓${NC} Will install $name (recommended)"
                    else
                        echo -e "  ${RED}✗${NC} Skipping $name"
                    fi
                    break
                    ;;
                *)
                    echo -e "${YELLOW}Please enter y, n, or q${NC}"
                    ;;
            esac
        done
    done
}

# Quick preset selections
get_preset_selections() {
    local -n preset_selections=$1
    
    echo -e "\n${YELLOW}📦 Quick Presets${NC}"
    echo "  1) Essential (5 apps): cursor, firefox, obsidian, rectangle, ghostty"
    echo "  2) Developer (8 apps): Essential + chrome, postman, vscode"
    echo "  3) Productivity (10 apps): Developer + slack, notion"
    echo "  4) Full Setup (15 apps): Productivity + raycast, stats, figma, vlc, iterm2"
    echo "  5) Custom selection (switch to interactive mode)"
    echo
    
    while true; do
        read -p "Choose preset [1-5]: " preset_choice
        case "$preset_choice" in
            1)
                preset_selections=(
                    "dev_cursor" "browser_firefox" "prod_obsidian" 
                    "util_rectangle" "term_ghostty"
                )
                break
                ;;
            2)
                preset_selections=(
                    "dev_cursor" "browser_firefox" "prod_obsidian" 
                    "util_rectangle" "term_ghostty" "browser_chrome" 
                    "dev_postman" "dev_vscode"
                )
                break
                ;;
            3)
                preset_selections=(
                    "dev_cursor" "browser_firefox" "prod_obsidian" 
                    "util_rectangle" "term_ghostty" "browser_chrome" 
                    "dev_postman" "dev_vscode" "prod_slack" "prod_notion"
                )
                break
                ;;
            4)
                preset_selections=(
                    "dev_cursor" "browser_firefox" "prod_obsidian" 
                    "util_rectangle" "term_ghostty" "browser_chrome" 
                    "dev_postman" "dev_vscode" "prod_slack" "prod_notion"
                    "util_raycast" "util_stats" "design_figma" "media_vlc" "term_iterm2"
                )
                break
                ;;
            5)
                get_interactive_selections preset_selections
                break
                ;;
            *)
                echo -e "${YELLOW}Please enter 1, 2, 3, 4, or 5${NC}"
                ;;
        esac
    done
}

# Legacy mode for typing app names
get_legacy_selections() {
    local -n legacy_selections=$1
    
    echo -e "\n${YELLOW}📝 Legacy Mode${NC}"
    echo "Available applications:"
    
    show_applications "dev" "Development Tools"
    show_applications "browser" "Browsers"
    show_applications "prod" "Productivity"
    show_applications "util" "macOS Utilities"
    show_applications "term" "Terminal & Development"
    show_applications "design" "Design & Media"
    show_applications "media" "Media"
    
    echo -e "\n${CYAN}Enter application names separated by spaces:${NC}"
    echo "Example: cursor firefox obsidian rectangle"
    echo
    
    read -p "Applications to install: " app_input
    
    # Parse input and validate
    for app in $app_input; do
        local found=false
        for key in "${!APPLICATIONS[@]}"; do
            local app_key="${key#*_}"
            if [[ "$app_key" == "$app" || "$key" == "$app" ]]; then
                legacy_selections+=("$key")
                found=true
                break
            fi
        done
        
        if [[ "$found" == false ]]; then
            warning "Unknown application: $app"
        fi
    done
}

# Main installation function
install_selected_applications() {
    local -a selected_apps=("$@")
    
    if [[ ${#selected_apps[@]} -eq 0 ]]; then
        warning "No applications selected for installation"
        return 0
    fi
    
    echo -e "\n${GREEN}📦 Installing Selected Applications${NC}"
    echo "Selected applications: ${#selected_apps[@]}"
    echo
    
    local installed_count=0
    local failed_apps=()
    
    for app_key in "${selected_apps[@]}"; do
        if [[ -n "${APPLICATIONS[$app_key]:-}" ]]; then
            IFS='|' read -r name url cask desc <<< "${APPLICATIONS[$app_key]}"
            
            if install_cask_app "$cask" "$name"; then
                ((installed_count++))
            else
                failed_apps+=("$name")
            fi
        else
            warning "Unknown application key: $app_key"
        fi
    done
    
    echo -e "\n${GREEN}📊 Installation Summary${NC}"
    echo "Successfully installed: $installed_count/${#selected_apps[@]} applications"
    
    if [[ ${#failed_apps[@]} -gt 0 ]]; then
        echo -e "\n${RED}Failed installations:${NC}"
        for app in "${failed_apps[@]}"; do
            echo "  • $app"
        done
    fi
}

# Main execution
main() {
    echo -e "${BLUE}"
    echo "╔══════════════════════════════════════╗"
    echo "║    macOS Application Installer       ║"
    echo "║        (Homebrew Casks)              ║"
    echo "╚══════════════════════════════════════╝"
    echo -e "${NC}"
    
    # Get user selections
    local -a user_apps=()
    get_user_selections user_apps
    
    # Install selected applications
    install_selected_applications "${user_apps[@]}"
    
    echo -e "\n${GREEN}🎉 Application installation completed!${NC}"
    echo "All applications are now available in your Applications folder."
}

# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi 
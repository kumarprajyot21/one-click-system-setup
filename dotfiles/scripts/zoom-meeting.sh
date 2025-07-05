#!/bin/bash

# macOS Zoom Meeting Launcher
# Opens Zoom meeting URLs and automatically closes the browser after launching

# Define your meeting mappings here (compatible with bash 3.x)
# Using Zoom app protocol instead of web URLs
get_meeting_url() {
    local key="$1"
    case "$key" in
        "570") echo "zoommtg://zoom.us/join?confno=5701573159&pwd=JrsqkDvQrXIaXlieb8kQ4QZDRnoZWu.1" ;;
        "386") echo "zoommtg://zoom.us/join?confno=3866392056&pwd=WHdoamFjeWV0UWxFTzVieFZhdGZFZz09" ;;
        "296") echo "zoommtg://zoom.us/join?confno=2967900418&pwd=MoteTx123%21" ;;
        *) echo "" ;;
    esac
}

# Get list of available shortcuts
get_meeting_keys() {
    echo "570 386 296"
}

# Configuration - No browser management needed since we're using Zoom app directly

key="$1"

show_usage() {
    echo "📱 macOS Zoom Meeting Launcher"
    echo ""
    echo "Usage: zoom-meeting <shortcut>"
    echo ""
    echo "Available shortcuts:"
    for k in $(get_meeting_keys); do
        echo "  $k"
    done
    echo ""
    echo "Commands:"
    echo "  list                List all available meetings"
    echo "  --help              Show this help message"
    echo ""
    echo "Examples:"
    echo "  zoom-meeting 570                    # Launch meeting 570 in Zoom app"
    echo "  zoom-meeting list                   # List all meetings"
    echo ""
    echo "ℹ️  This script launches meetings directly in the Zoom app (no browser required)"
}

# Parse options
while [[ $# -gt 0 ]]; do
    case $1 in
        --help)
            show_usage
            exit 0
            ;;
        *)
            if [[ -z "$key" ]]; then
                key="$1"
            fi
            shift
            ;;
    esac
done

# Handle special commands first
case "$key" in
    "list")
        echo "Available meeting shortcuts:"
        for k in $(get_meeting_keys); do
            url=$(get_meeting_url "$k")
            echo "  $k: $url"
        done
        exit 0
        ;;
    "--help"|"")
        show_usage
        exit 0
        ;;
esac

url=$(get_meeting_url "$key")

if [[ -z "$url" ]]; then
    echo "No meeting found for shortcut: $key"
    exit 1
fi



# Function to open Zoom meeting directly in the app
open_zoom_meeting() {
    local url="$1"
    echo "🚀 Launching Zoom meeting: $url"
    
    # Open the URL directly in the Zoom app
    open "$url"
    
    # Brief pause to ensure the URL is processed
    sleep 1
    
    echo "✅ Zoom meeting launched successfully!"
    echo "📱 The meeting should now be opening in your Zoom app."
}

# Open the meeting
open_zoom_meeting "$url" 
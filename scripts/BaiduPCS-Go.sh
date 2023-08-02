#!/bin/bash
bindir="$HOME/.local/bin"   # Directory where the program will be installed
programname="BaiduPCS-Go"   # Name of the program to be installed
username="qjfoidnh"         # GitHub username of the repository owner
repository="BaiduPCS-Go"    # Name of the GitHub repository

# Function to get the latest release tag of the repository
get_latest_tag() {
    local api_url="https://api.github.com/repos/$username/$repository/releases/latest"
    local response=$(curl -s "$api_url")
    echo "$response" | grep -o '"tag_name": *"[^"]*"' | awk -F'"' '{print $4}'
}

# Function to get the system architecture (e.g., amd64, arm64)
get_architecture() {
    local architecture=$(uname -m)
    case "$architecture" in
        "x86_64") echo "amd64" ;;
        "arm64") echo "arm64" ;;
        *) echo "unsupported" ;;  # Unsupported architecture
    esac
}

# Function to get the operating system (e.g., linux, darwin-osx)
get_operating_system() {
    local operating_system=$(uname -s)
    case "$operating_system" in
        "Darwin") echo "darwin-osx" ;;
        "Linux") echo "linux" ;;
        *) echo "unsupported" ;;  # Unsupported operating system
    esac
}

# Function to download and install the program
download_and_install() {
    local latest_tag="$1"
    local operating_system="$2"
    local architecture="$3"

    local filename="BaiduPCS-Go-$latest_tag-$operating_system-$architecture"
    local zipname="$filename.zip"

    rm -f "$bindir/$programname"  # Remove any existing installation
    mkdir -p "$bindir"            # Create the installation directory
    wget -q "https://github.com/$username/$repository/releases/download/$latest_tag/$zipname" -O "$bindir/$zipname"  # Download the program release
    unzip -q -j "$bindir/$zipname" "$filename/$programname" -d "$bindir"  # Extract the binary and move it to the installation directory
    rm "$bindir/$zipname"  # Remove the downloaded zip file
    chmod +x "$bindir/$programname"  # Make the program executable

    echo "BaiduPCS-Go has been successfully installed!"
}

# Check for required commands (curl, wget, unzip)
if ! command -v curl >/dev/null 2>&1; then
    echo "curl is not installed. Please install it and try again."
    exit 1
fi

if ! command -v wget >/dev/null 2>&1; then
    echo "wget is not installed. Please install it and try again."
    exit 1
fi

if ! command -v unzip >/dev/null 2>&1; then
    echo "unzip is not installed. Please install it and try again."
    exit 1
fi

latest_tag=$(get_latest_tag)
if [ -z "$latest_tag" ]; then
    echo "Failed to retrieve the latest version tag."
    exit 1
fi

architecture=$(get_architecture)
if [ "$architecture" = "unsupported" ]; then
    echo "Unsupported architecture: $(uname -m)"
    exit 1
fi

operating_system=$(get_operating_system)
if [ "$operating_system" = "unsupported" ]; then
    echo "Unsupported operating system: $(uname -s)"
    exit 1
fi

download_and_install "$latest_tag" "$operating_system" "$architecture"

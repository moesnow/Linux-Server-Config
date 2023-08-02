#!/bin/bash
bindir="$HOME/.local/bin"
programnamedir="$HOME/.local/BBDown"
programname="BBDown"
username="nilaoda"
repository="BBDown"

api_url="https://api.github.com/repos/$username/$repository/releases/latest"
response=$(curl -s "$api_url")
arch=$(uname -m)
system=$(uname -s)

# Check if wget and unzip are available
if ! command -v wget >/dev/null || ! command -v unzip >/dev/null; then
    echo "Please install wget and unzip to continue."
    exit 1
fi

# Function to handle errors
function handle_error() {
    echo "Error: $1"
    exit 1
}

# Define download function
function download_and_extract() {
    local zipurl=$1
    local zipname=$(basename "$zipurl")

    # Download the zip
    wget -q "$zipurl" -O "$programnamedir/$zipname" || handle_error "Failed to download $zipname"

    # Extract the program
    unzip -q -j "$programnamedir/$zipname" "$programname" -d "$programnamedir" || handle_error "Failed to extract $zipname"

    # Clean up
    rm "$programnamedir/$zipname"
}

# Set the appropriate zip URL based on system and architecture
case $system-$arch in
    Darwin-x86_64)
        zipurl=$(echo "$response" | grep -o "https://.*_osx-x64.zip")
        ;;
    Darwin-arm64)
        zipurl=$(echo "$response" | grep -o "https://.*_osx-arm64.zip")
        ;;
    Linux-x86_64)
        zipurl=$(echo "$response" | grep -o "https://.*_linux-x64.zip")
        ;;
    Linux-arm64)
        zipurl=$(echo "$response" | grep -o "https://.*_linux-arm64.zip")
        ;;
    *)
        echo "Unsupported system or architecture."
        exit 1
        ;;
esac

# Clean up existing installation
rm -rf "$programnamedir"
rm -f "$bindir/$programname"

# Create directories
mkdir -p "$programnamedir"
mkdir -p "$bindir"

# Download and extract the program
download_and_extract "$zipurl"

# Make the program executable and create symbolic link
chmod +x "$programnamedir/$programname"
ln -s "$programnamedir/$programname" "$bindir/$programname"

# Create symbolic links for BBDown.data and BBDownTV.data
ln -s "$HOME/.config/BBDown/BBDown.data" "$programnamedir/BBDown.data"
ln -s "$HOME/.config/BBDown/BBDownTV.data" "$programnamedir/BBDownTV.data"

echo "BBDown has been successfully installed!"

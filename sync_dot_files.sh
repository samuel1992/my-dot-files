#!/bin/bash

# Dotfiles Sync Script
# This script copies configuration files from their system locations to this repository

set -e  # Exit on error

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

echo "Starting dotfiles sync..."
echo ""

# Create directory structure
echo "Creating directory structure..."
mkdir -p alacritty
mkdir -p zsh
mkdir -p nvim

# Sync Alacritty configuration
echo "Syncing Alacritty configuration..."
if [ -f "$HOME/.config/alacritty/alacritty.toml" ]; then
    cp "$HOME/.config/alacritty/alacritty.toml" alacritty/alacritty.toml
    echo "  ✓ Copied alacritty.toml"
else
    echo "  ✗ alacritty.toml not found"
fi

# Sync Alacritty themes
echo "Syncing Alacritty themes..."
if [ -d "$HOME/.config/alacritty/themes" ]; then
    # Remove existing themes directory if it exists
    rm -rf alacritty/themes
    cp -r "$HOME/.config/alacritty/themes" alacritty/themes
    # Remove .git directory from copied themes
    rm -rf alacritty/themes/.git
    THEME_COUNT=$(find alacritty/themes/themes -type f -name "*.toml" 2>/dev/null | wc -l | tr -d ' ')
    echo "  ✓ Copied themes directory ($THEME_COUNT themes)"
else
    echo "  ✗ Alacritty themes directory not found"
fi

# Sync Zsh configuration with modifications
echo "Syncing Zsh configuration..."
if [ -f "$HOME/.zshrc" ]; then
    # Copy .zshrc and modify sensitive lines
    sed -e '42s/^/# /' \
        -e '43s/^/# /' \
        -e '42i\
# NOTE: The following lines are commented out for security.\
# Create your own ~/.aikeys.sh and ~/.sshclients.sh files with your sensitive data.' \
        "$HOME/.zshrc" > zsh/.zshrc
    echo "  ✓ Copied .zshrc (with sensitive lines commented out)"
else
    echo "  ✗ .zshrc not found"
fi

# Sync Neovim configuration
echo "Syncing Neovim configuration..."
if [ -d "$HOME/.config/nvim" ]; then
    # Remove existing nvim directory if it exists
    rm -rf nvim
    cp -r "$HOME/.config/nvim" nvim
    # Remove .git directory and git-related files
    rm -rf nvim/.git
    rm -f nvim/.gitignore
    NVIM_FILES=$(find nvim -type f \( -name "*.lua" -o -name "*.vim" \) 2>/dev/null | wc -l | tr -d ' ')
    echo "  ✓ Copied nvim configuration ($NVIM_FILES config files)"
else
    echo "  ✗ Neovim configuration directory not found"
fi

echo ""
echo "Sync complete!"
echo ""
echo "Summary of synced files:"
echo "  - alacritty/alacritty.toml"
echo "  - alacritty/themes/ (full directory)"
echo "  - zsh/.zshrc (sensitive sources commented out)"
echo "  - nvim/ (full configuration directory)"

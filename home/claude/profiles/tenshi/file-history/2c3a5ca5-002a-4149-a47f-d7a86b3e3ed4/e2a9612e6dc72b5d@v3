#!/bin/bash
# Bash Config Setup Script
# Run this after cloning to ~/.config/bash

echo "Setting up bash configuration..."

# Step 1: Create symlinks (works on all systems)
echo ""
echo "Step 1: Creating shell configuration symlinks..."
ln -sf "$HOME/.config/bash/bashrc" "$HOME/.bashrc"
ln -sf "$HOME/.config/bash/profile" "$HOME/.profile"
echo "Created symlinks:"
echo "  ~/.bashrc -> ~/.config/bash/bashrc"
echo "  ~/.profile -> ~/.config/bash/profile"

# Step 1.5: Create workspace structure
echo ""
echo "Step 1.5: Creating workspace structure..."
bash "$HOME/.config/bash/lib/init-workspace.sh"

# Step 2: Detect OS and setup package management
echo ""
echo "Step 2: Setting up package management..."

source "$HOME/.config/bash/lib/os-detect.sh"
PKG_MGR=$(detect_package_manager)
OS=$(detect_os)

echo "Detected OS: $OS"
echo "Package manager: $PKG_MGR"

# Setup repositories (only apt needs this)
if [[ "$PKG_MGR" == "apt" ]]; then
    echo ""
    echo "Setting up apt repositories..."
    bash "$HOME/.config/bash/lib/apt-repos.sh"
fi

# Install universal packages (works for any supported package manager)
if [[ -f "$HOME/.config/bash/lib/${PKG_MGR}-packages.sh" ]]; then
    echo ""
    echo "Installing universal packages..."
    bash "$HOME/.config/bash/bin/bashrc" install universal
else
    echo ""
    echo "Unsupported package manager: $PKG_MGR"
    echo "You'll need to manually install packages"
fi

# Step 3: Source configuration
echo ""
echo "Step 3: Loading new configuration..."
source "$HOME/.profile"

echo ""
echo "Setup complete"
echo ""
echo "  - Run 'reload' to apply changes"
echo "  - Run 'bashrc install dev-tools' for dev tools"
echo "  - Run 'bashrc' to see available commands"

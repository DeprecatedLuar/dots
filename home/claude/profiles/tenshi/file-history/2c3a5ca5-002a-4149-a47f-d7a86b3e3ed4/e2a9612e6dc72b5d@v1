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

# Step 2: Detect OS and setup package management
echo ""
echo "Step 2: Setting up package management..."

source "$HOME/.config/bash/lib/os-detect.sh"
PKG_MGR=$(detect_package_manager)
OS=$(detect_os)

echo "Detected OS: $OS"
echo "Package manager: $PKG_MGR"

if [[ "$PKG_MGR" == "apt" ]]; then
    echo ""
    echo "Setting up apt repositories..."
    bash "$HOME/.config/bash/lib/apt-repos.sh"
    
    echo ""
    echo "Installing universal packages..."
    bash "$HOME/.config/bash/bin/bashrc" install universal
else
    echo ""
    echo "Non-Debian system detected - skipping package installation"
    echo "You'll need to manually install: zoxide, ranger, micro, git, curl, wget"
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

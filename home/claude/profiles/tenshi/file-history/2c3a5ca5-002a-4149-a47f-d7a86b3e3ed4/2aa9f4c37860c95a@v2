#!/bin/bash
# Repository Setup Script - Enable additional Ubuntu repositories
# Called by setup.sh

set -e  # Exit on any error

echo "Setting up repositories..."

# Enable universe repository (for zoxide, ranger and other packages)
echo "  Enabling universe repository..."
sudo add-apt-repository universe -y

# Enable multiverse repository (for additional software)
echo "  Enabling multiverse repository..."
sudo add-apt-repository multiverse -y

# Add Go backports PPA for latest Go version
echo "  Adding Go backports PPA..."
sudo add-apt-repository ppa:longsleep/golang-backports -y

# Add NodeSource PPA for latest Node.js LTS
echo "  Adding NodeSource PPA..."
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -

# Update package list after adding all PPAs
echo "  Updating package lists..."
sudo apt update

echo "Repository setup complete!"
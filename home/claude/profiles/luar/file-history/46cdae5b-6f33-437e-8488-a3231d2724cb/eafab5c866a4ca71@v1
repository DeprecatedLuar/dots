#!/bin/bash

UNIVERSAL=(
    "curl"
    "wget"
    "git"
    "zoxide"
    "ranger"
    "micro"
    "visidata"
)

DEV_TOOLS=(
    "golang-go"
    "nodejs"
)

install_packages() {
    for package in "$@"; do
        echo "Installing $package..."
        sudo apt install -y "$package" || echo "Failed - skipping"
    done
}

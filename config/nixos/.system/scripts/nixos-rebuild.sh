#!/usr/bin/env bash
set -euo pipefail

# Self-healing nixos-rebuild wrapper
# Ensures /etc/nixos and root-level symlinks are properly configured

# Parse flags
args=()
bypass=false
meltdown=false
for arg; do
    if [[ "$arg" == "--bypass" ]]; then
        bypass=true
    elif [[ "$arg" == "--meltdown" ]]; then
        meltdown=true
    else
        args+=("$arg")
    fi
done

if $bypass; then
    rebuild_bin=$(nix-build '<nixpkgs/nixos>' -A config.system.build.nixos-rebuild --no-out-link)/bin/nixos-rebuild
    exec "$rebuild_bin" "${args[@]}"
fi

HOSTNAME=$(hostname)

# Find CONFIG_DIR from /etc/nixos symlink or fallback
if [[ -L "/etc/nixos" ]]; then
    CONFIG_DIR=$(readlink -f "/etc/nixos")
else
    # Fallback: try to find .config/nixos in common locations
    for possible_home in /home/*; do
        if [[ -d "$possible_home/.config/nixos/.system/machines/$HOSTNAME" ]]; then
            CONFIG_DIR="$possible_home/.config/nixos"
            break
        fi
    done

    if [[ -z "${CONFIG_DIR:-}" ]]; then
        echo "Error: Cannot find nixos config directory" >&2
        exit 1
    fi
fi

SYS_DIR="$CONFIG_DIR/.system"
MACHINES_DIR="$SYS_DIR/machines"
USERS_DIR="$SYS_DIR/users"
MACHINE_DIR="$MACHINES_DIR/$HOSTNAME"

# Check if machine config exists
if [[ ! -d "$MACHINE_DIR" ]]; then
    echo "Error: Machine config not found: $MACHINE_DIR" >&2
    exit 1
fi

# Parse mainUser from configuration.nix
MAIN_USER=$(awk '/mainUser = / {match($0, /"([^"]+)"/, arr); print arr[1]}' "$MACHINE_DIR/configuration.nix")
if [[ -z "$MAIN_USER" ]]; then
    echo "Error: Could not parse mainUser from configuration.nix" >&2
    exit 1
fi

# Ensure /etc/nixos folder symlink is correct
if [[ ! -L "/etc/nixos" ]] || [[ "$(readlink -f /etc/nixos)" != "$CONFIG_DIR" ]]; then
    echo "Updating /etc/nixos symlink for machine: $HOSTNAME"
    sudo rm -rf /etc/nixos
    sudo ln -s "$CONFIG_DIR" /etc/nixos
fi

# Auto-heal root-level symlinks: machine files (except default.nix and services.nix)
for file in "$MACHINE_DIR"/*.nix; do
    if [[ -f "$file" ]]; then
        filename=$(basename "$file")
        if [[ "$filename" != "default.nix" && "$filename" != "services.nix" ]]; then
            target=".system/machines/$HOSTNAME/$filename"
            link="$CONFIG_DIR/$filename"

            if [[ ! -L "$link" ]] || [[ "$(readlink "$link")" != "$target" ]]; then
                rm -f "$link"
                ln -s "$target" "$link"
            fi
        fi
    fi
done

# Auto-heal root-level symlink: user file
if [[ -f "$USERS_DIR/$MAIN_USER.nix" ]]; then
    target=".system/users/$MAIN_USER.nix"
    link="$CONFIG_DIR/$MAIN_USER.nix"

    if [[ ! -L "$link" ]] || [[ "$(readlink "$link")" != "$target" ]]; then
        rm -f "$link"
        ln -s "$target" "$link"
    fi
fi

# Auto-heal root-level symlink: services folder
target=".system/services"
link="$CONFIG_DIR/services"

if [[ ! -L "$link" ]] || [[ "$(readlink "$link")" != "$target" ]]; then
    rm -f "$link"
    ln -s "$target" "$link"
fi

# Service symlink-farm: Self-healing service management
SERVICES_DIR="$SYS_DIR/services"
SERVICES_AVAILABLE="$SERVICES_DIR/available"
MACHINE_SERVICES_DIR="$MACHINE_DIR/services"
MACHINE_SERVICES_CONFIG="$MACHINE_DIR/services.nix"

# Ensure directories exist
mkdir -p "$SERVICES_AVAILABLE"

# Clean broken symlinks in services/available/
find "$SERVICES_AVAILABLE" -type l ! -exec test -e {} \; -delete 2>/dev/null || true

# Symlink machine services.nix → .system/services/services.nix
if [[ -f "$MACHINE_SERVICES_CONFIG" ]]; then
    SERVICES_CONFIG_LINK="$SERVICES_DIR/services.nix"
    if [[ ! -L "$SERVICES_CONFIG_LINK" ]] || [[ "$(readlink -f "$SERVICES_CONFIG_LINK")" != "$MACHINE_SERVICES_CONFIG" ]]; then
        echo "Symlinking services config: machines/$HOSTNAME/services.nix → .system/services/services.nix"
        rm -f "$SERVICES_CONFIG_LINK"
        ln -s "$MACHINE_SERVICES_CONFIG" "$SERVICES_CONFIG_LINK"
    fi
fi

# Symlink machine-specific services: machines/$HOSTNAME/services/*.nix → .system/services/available/local_*.nix
if [[ -d "$MACHINE_SERVICES_DIR" ]]; then
    for service_file in "$MACHINE_SERVICES_DIR"/*.nix; do
        if [[ -f "$service_file" ]]; then
            service_name=$(basename "$service_file")
            local_link="$SERVICES_AVAILABLE/local_$service_name"
            if [[ ! -L "$local_link" ]] || [[ "$(readlink -f "$local_link")" != "$service_file" ]]; then
                echo "Symlinking machine service: $service_name → local_$service_name"
                rm -f "$local_link"
                ln -s "$service_file" "$local_link"
            fi
        fi
    done
fi

# Call the real nixos-rebuild from nixpkgs
rebuild_bin=$(nix-build '<nixpkgs/nixos>' -A config.system.build.nixos-rebuild --no-out-link)/bin/nixos-rebuild

if $meltdown; then
    exec meltdown "$rebuild_bin" "${args[@]}"
else
    exec "$rebuild_bin" "${args[@]}"
fi

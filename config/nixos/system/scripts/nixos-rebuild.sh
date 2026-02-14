#!/usr/bin/env bash
set -euo pipefail

# Self-healing nixos-rebuild wrapper
# Ensures /etc/nixos/configuration.nix symlink points to correct machine config

# Parse --bypass flag
args=()
bypass=false
for arg; do
    if [[ "$arg" == "--bypass" ]]; then
        bypass=true
    else
        args+=("$arg")
    fi
done

if $bypass; then
    rebuild_bin=$(nix-build '<nixpkgs/nixos>' -A config.system.build.nixos-rebuild --no-out-link)/bin/nixos-rebuild
    exec "$rebuild_bin" "${args[@]}"
fi

HOSTNAME=$(hostname)
NIXOS_CONFIG="/etc/nixos/configuration.nix"

# Derive CONFIG_DIR from existing symlink or fallback logic
if [[ -L "$NIXOS_CONFIG" ]]; then
    # Extract config dir from existing symlink path
    # e.g., /home/user/.config/nixos/machines/hostname/configuration.nix -> /home/user/.config/nixos
    SYMLINK_TARGET=$(readlink -f "$NIXOS_CONFIG")
    CONFIG_DIR=$(dirname "$(dirname "$(dirname "$SYMLINK_TARGET")")")
else
    # Fallback: try to find .config/nixos in common locations
    for possible_home in /home/*; do
        if [[ -d "$possible_home/.config/nixos/machines/$HOSTNAME" ]]; then
            CONFIG_DIR="$possible_home/.config/nixos"
            break
        fi
    done

    if [[ -z "${CONFIG_DIR:-}" ]]; then
        echo "Error: Cannot find nixos config directory" >&2
        exit 1
    fi
fi

MACHINE_CONFIG="${CONFIG_DIR}/machines/${HOSTNAME}/configuration.nix"

# Check if machine config exists
if [[ ! -f "$MACHINE_CONFIG" ]]; then
    echo "Error: Machine config not found: $MACHINE_CONFIG" >&2
    exit 1
fi

# Check if symlink needs updating
if [[ ! -L "$NIXOS_CONFIG" ]] || [[ "$(readlink -f "$NIXOS_CONFIG")" != "$MACHINE_CONFIG" ]]; then
    echo "Updating /etc/nixos/configuration.nix symlink for machine: $HOSTNAME"
    sudo rm -f "$NIXOS_CONFIG"
    sudo ln -s "$MACHINE_CONFIG" "$NIXOS_CONFIG"
fi

# Create convenience symlink in config directory for easy editing
CONVENIENCE_LINK="${CONFIG_DIR}/configuration.nix"
if [[ ! -L "$CONVENIENCE_LINK" ]] || [[ "$(readlink -f "$CONVENIENCE_LINK")" != "$MACHINE_CONFIG" ]]; then
    echo "Creating convenience symlink: ${CONVENIENCE_LINK}"
    rm -f "$CONVENIENCE_LINK"
    ln -s "$MACHINE_CONFIG" "$CONVENIENCE_LINK"
fi

# Service symlink-farm: Self-healing service management
SERVICES_DIR="${CONFIG_DIR}/services"
SERVICES_AVAILABLE="${SERVICES_DIR}/available"
MACHINE_SERVICES_DIR="${CONFIG_DIR}/machines/${HOSTNAME}/services"
MACHINE_SERVICES_CONFIG="${CONFIG_DIR}/machines/${HOSTNAME}/services.nix"

# Ensure directories exist
mkdir -p "$SERVICES_AVAILABLE"

# Clean broken symlinks in services/available/
find "$SERVICES_AVAILABLE" -type l ! -exec test -e {} \; -delete 2>/dev/null || true

# Symlink machine services.nix → services/services.nix
if [[ -f "$MACHINE_SERVICES_CONFIG" ]]; then
    SERVICES_CONFIG_LINK="${SERVICES_DIR}/services.nix"
    if [[ ! -L "$SERVICES_CONFIG_LINK" ]] || [[ "$(readlink -f "$SERVICES_CONFIG_LINK")" != "$MACHINE_SERVICES_CONFIG" ]]; then
        echo "Symlinking services config: machines/${HOSTNAME}/services.nix → services/services.nix"
        rm -f "$SERVICES_CONFIG_LINK"
        ln -s "$MACHINE_SERVICES_CONFIG" "$SERVICES_CONFIG_LINK"
    fi
fi

# Symlink machine-specific services: machines/${HOSTNAME}/services/*.nix → services/available/local_*.nix
if [[ -d "$MACHINE_SERVICES_DIR" ]]; then
    for service_file in "$MACHINE_SERVICES_DIR"/*.nix; do
        if [[ -f "$service_file" ]]; then
            service_name=$(basename "$service_file")
            local_link="${SERVICES_AVAILABLE}/local_${service_name}"
            if [[ ! -L "$local_link" ]] || [[ "$(readlink -f "$local_link")" != "$service_file" ]]; then
                echo "Symlinking machine service: ${service_name} → local_${service_name}"
                rm -f "$local_link"
                ln -s "$service_file" "$local_link"
            fi
        fi
    done
fi

# Call the real nixos-rebuild from nixpkgs
rebuild_bin=$(nix-build '<nixpkgs/nixos>' -A config.system.build.nixos-rebuild --no-out-link)/bin/nixos-rebuild
exec "$rebuild_bin" "$@"

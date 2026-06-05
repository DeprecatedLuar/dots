#!/usr/bin/env bash
set -euo pipefail

# Generate configuration.nix from machine.toml
# Usage: generate-config.sh <machine-dir>

MACHINE_DIR="${1:-.}"
MACHINE_TOML="$MACHINE_DIR/machine.toml"
OUTPUT_FILE="$MACHINE_DIR/configuration.nix"
TEMPLATE_FILE="$(dirname "$0")/machine.toml.template"
SCRIPT_DIR="$(dirname "$0")"
SYS_DIR="$(realpath "$SCRIPT_DIR/..")"

# Discover available modules and users
discover_modules() {
    local modules_dir="$SYS_DIR/modules"
    if [[ -d "$modules_dir" ]]; then
        find "$modules_dir" -maxdepth 1 -name "*.nix" -type f \
            | xargs -I{} basename {} .nix \
            | sort
    fi
}

discover_users() {
    local users_dir="$SYS_DIR/users"
    if [[ -d "$users_dir" ]]; then
        find "$users_dir" -maxdepth 1 -name "*.nix" -type f \
            | xargs -I{} basename {} .nix \
            | sort
    fi
}

# Generate template with auto-discovered options
generate_template() {
    local output=$1
    local available_modules=($(discover_modules))
    local available_users=($(discover_users))

    cat > "$output" << 'EOF'
# NixOS Machine Configuration
# Auto-generated template - edit as needed

EOF

    # Add available users as comments (FIRST - most important)
    echo "# Users to import from .system/users/" >> "$output"
    echo "# First user is the main user (auto-login, home directory for configs)" >> "$output"
    if [[ ${#available_users[@]} -gt 0 ]]; then
        echo "# Available:" >> "$output"
        for user in "${available_users[@]}"; do
            echo "#   - $user" >> "$output"
        done
    fi
    echo "users = []" >> "$output"

    cat >> "$output" << 'EOF'
hostName = "hostname"
timeZone = "America/Sao_Paulo"
locale = "en_US.UTF-8"

# Desktop compositors (leave empty for headless)
# Options: hyprland, niri, xfce, i3, openbox
compositors = []

EOF

    # Add available modules as comments
    echo "# Modules to import from .system/modules/" >> "$output"
    if [[ ${#available_modules[@]} -gt 0 ]]; then
        echo "# Available:" >> "$output"
        for module in "${available_modules[@]}"; do
            echo "#   - $module" >> "$output"
        done
    fi
    echo "modules = []" >> "$output"
}

# Parse TOML string value (key = "value")
parse_string() {
    local file=$1
    local key=$2
    grep "^$key" "$file" | sed 's/.*= *"\(.*\)".*/\1/' | head -1
}

# Parse TOML array (key = ["a", "b", "c"])
parse_array() {
    local file=$1
    local key=$2
    grep "^$key" "$file" | sed 's/.*= *\[\(.*\)\].*/\1/' | tr ',' '\n' | sed 's/^[" \t]*//; s/[" \t]*$//' | grep -v '^$'
}

# Convert array to Nix list format ("a" "b" "c")
to_nix_list() {
    local items=()
    while IFS= read -r line; do
        [[ -n "$line" ]] && items+=("\"$line\"")
    done
    echo "${items[@]}"
}

# Validate TOML file structure
validate_toml() {
    local file=$1
    local required_keys=("hostName" "timeZone" "locale" "compositors" "users" "modules")
    local errors=()

    # Check for required keys
    for key in "${required_keys[@]}"; do
        if ! grep -q "^$key" "$file"; then
            errors+=("Missing required key: $key")
        fi
    done

    # Check for unexpected keys (non-comment, non-empty lines)
    while IFS= read -r line; do
        # Skip comments and empty lines
        [[ "$line" =~ ^[[:space:]]*# ]] && continue
        [[ "$line" =~ ^[[:space:]]*$ ]] && continue

        # Extract key name
        key=$(echo "$line" | sed 's/^\([a-zA-Z]*\).*/\1/')

        # Check if key is valid
        if [[ ! " ${required_keys[@]} " =~ " $key " ]]; then
            errors+=("Unknown key: $key")
        fi
    done < "$file"

    # Report errors
    if [[ ${#errors[@]} -gt 0 ]]; then
        echo "Error: Invalid TOML format in $file"
        printf '  - %s\n' "${errors[@]}"
        exit 1
    fi
}

# Check if machine.toml exists, create from template if not
if [[ ! -f "$MACHINE_TOML" ]]; then
    echo "Creating $MACHINE_TOML from template..."
    generate_template "$MACHINE_TOML"
    echo "✓ Created template with auto-discovered modules and users"
    exit 1
fi

# Validate TOML structure
validate_toml "$MACHINE_TOML"

# Parse variables
HOST_NAME=$(parse_string "$MACHINE_TOML" hostName)
TIME_ZONE=$(parse_string "$MACHINE_TOML" timeZone)
LOCALE=$(parse_string "$MACHINE_TOML" locale)

# Derive main user from first user in array
MAIN_USER=$(parse_array "$MACHINE_TOML" users | head -1)

# Validate required fields
if [[ -z "$MAIN_USER" ]]; then
    echo "Error: users array must have at least one user in $MACHINE_TOML"
    exit 1
fi

if [[ -z "$HOST_NAME" ]]; then
    echo "Error: hostName is required in $MACHINE_TOML"
    exit 1
fi

# Parse arrays and convert to Nix format
COMPOSITORS=$(parse_array "$MACHINE_TOML" compositors | to_nix_list)
USERS=$(parse_array "$MACHINE_TOML" users | to_nix_list)
MODULES=$(parse_array "$MACHINE_TOML" modules | to_nix_list)

# Generate user imports
USER_IMPORTS=()
while IFS= read -r user; do
    [[ -n "$user" ]] && USER_IMPORTS+=("    ../../users/${user}.nix")
done < <(parse_array "$MACHINE_TOML" users)

# Generate module imports
MODULE_IMPORTS=()
while IFS= read -r module; do
    [[ -n "$module" ]] && MODULE_IMPORTS+=("    ../../modules/${module}.nix")
done < <(parse_array "$MACHINE_TOML" modules)

# Combine all imports
ALL_IMPORTS=$(printf '%s\n' "${USER_IMPORTS[@]}" "${MODULE_IMPORTS[@]}")

# Generate configuration.nix
cat > "$OUTPUT_FILE" << EOF
# Auto-generated from machine.toml - DO NOT EDIT
# Edit machine.toml and run: sudo nixos-rebuild switch

{ ... }:

let
  mainUser = "$MAIN_USER";
  hostName = "$HOST_NAME";
  compositors = [ $COMPOSITORS ];
in
{
  time.timeZone = "$TIME_ZONE";
  i18n.defaultLocale = "$LOCALE";

  imports = [
    ../../system.nix
    ./default.nix
$ALL_IMPORTS
  ];

  networking.hostName = hostName;
  _module.args = { inherit mainUser hostName compositors; };
}
EOF

echo "✓ Generated: $OUTPUT_FILE"

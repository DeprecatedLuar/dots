#!/bin/bash
# Bash configuration magazine

# Ensure local configuration files exist
mkdir -p ~/.config/bash/modules/local
touch ~/.config/bash/modules/local/aliases.sh
touch ~/.config/bash/modules/local/paths.sh

# Source all module files
source ~/.config/bash/modules/universal/aliases.sh
source ~/.config/bash/modules/universal/paths.sh
# Source local files
source ~/.config/bash/modules/local/aliases.sh
source ~/.config/bash/modules/local/paths.sh

# Initialize zoxide (suppress write permission errors)
eval "$(zoxide init bash)"


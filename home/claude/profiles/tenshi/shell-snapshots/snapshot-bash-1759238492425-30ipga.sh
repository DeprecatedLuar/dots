# Snapshot file
# Unset all aliases to avoid conflicts with functions
unalias -a 2>/dev/null || true
# Functions
eval "$(echo 'Z2F3a2xpYnBhdGhfYXBwZW5kICgpIAp7IAogICAgWyAteiAiJEFXS0xJQlBBVEgiIF0gJiYgQVdL
TElCUEFUSD1gZ2F3ayAnQkVHSU4ge3ByaW50IEVOVklST05bIkFXS0xJQlBBVEgiXX0nYDsKICAg
IGV4cG9ydCBBV0tMSUJQQVRIPSIkQVdLTElCUEFUSDokKiIKfQo=' | base64 -d)" > /dev/null 2>&1
eval "$(echo 'Z2F3a2xpYnBhdGhfZGVmYXVsdCAoKSAKeyAKICAgIHVuc2V0IEFXS0xJQlBBVEg7CiAgICBleHBv
cnQgQVdLTElCUEFUSD1gZ2F3ayAnQkVHSU4ge3ByaW50IEVOVklST05bIkFXS0xJQlBBVEgiXX0n
YAp9Cg==' | base64 -d)" > /dev/null 2>&1
eval "$(echo 'Z2F3a2xpYnBhdGhfcHJlcGVuZCAoKSAKeyAKICAgIFsgLXogIiRBV0tMSUJQQVRIIiBdICYmIEFX
S0xJQlBBVEg9YGdhd2sgJ0JFR0lOIHtwcmludCBFTlZJUk9OWyJBV0tMSUJQQVRIIl19J2A7CiAg
ICBleHBvcnQgQVdLTElCUEFUSD0iJCo6JEFXS0xJQlBBVEgiCn0K' | base64 -d)" > /dev/null 2>&1
eval "$(echo 'Z2F3a3BhdGhfYXBwZW5kICgpIAp7IAogICAgWyAteiAiJEFXS1BBVEgiIF0gJiYgQVdLUEFUSD1g
Z2F3ayAnQkVHSU4ge3ByaW50IEVOVklST05bIkFXS1BBVEgiXX0nYDsKICAgIGV4cG9ydCBBV0tQ
QVRIPSIkQVdLUEFUSDokKiIKfQo=' | base64 -d)" > /dev/null 2>&1
eval "$(echo 'Z2F3a3BhdGhfZGVmYXVsdCAoKSAKeyAKICAgIHVuc2V0IEFXS1BBVEg7CiAgICBleHBvcnQgQVdL
UEFUSD1gZ2F3ayAnQkVHSU4ge3ByaW50IEVOVklST05bIkFXS1BBVEgiXX0nYAp9Cg==' | base64 -d)" > /dev/null 2>&1
eval "$(echo 'Z2F3a3BhdGhfcHJlcGVuZCAoKSAKeyAKICAgIFsgLXogIiRBV0tQQVRIIiBdICYmIEFXS1BBVEg9
YGdhd2sgJ0JFR0lOIHtwcmludCBFTlZJUk9OWyJBV0tQQVRIIl19J2A7CiAgICBleHBvcnQgQVdL
UEFUSD0iJCo6JEFXS1BBVEgiCn0K' | base64 -d)" > /dev/null 2>&1
# Shell Options
shopt -u autocd
shopt -u assoc_expand_once
shopt -u cdable_vars
shopt -u cdspell
shopt -u checkhash
shopt -u checkjobs
shopt -s checkwinsize
shopt -s cmdhist
shopt -u compat31
shopt -u compat32
shopt -u compat40
shopt -u compat41
shopt -u compat42
shopt -u compat43
shopt -u compat44
shopt -s complete_fullquote
shopt -u direxpand
shopt -u dirspell
shopt -u dotglob
shopt -u execfail
shopt -u expand_aliases
shopt -u extdebug
shopt -u extglob
shopt -s extquote
shopt -u failglob
shopt -s force_fignore
shopt -s globasciiranges
shopt -u globstar
shopt -u gnu_errfmt
shopt -u histappend
shopt -u histreedit
shopt -u histverify
shopt -s hostcomplete
shopt -u huponexit
shopt -u inherit_errexit
shopt -s interactive_comments
shopt -u lastpipe
shopt -u lithist
shopt -u localvar_inherit
shopt -u localvar_unset
shopt -s login_shell
shopt -u mailwarn
shopt -u no_empty_cmd_completion
shopt -u nocaseglob
shopt -u nocasematch
shopt -u nullglob
shopt -s progcomp
shopt -u progcomp_alias
shopt -s promptvars
shopt -u restricted_shell
shopt -u shift_verbose
shopt -s sourcepath
shopt -u xpg_echo
set -o braceexpand
set -o hashall
set -o interactive-comments
set -o monitor
set -o onecmd
shopt -s expand_aliases
# Aliases
# Check for rg availability
if ! command -v rg >/dev/null 2>&1; then
  alias rg='/home/luar/.config/bash/dev-tools/npm/lib/node_modules/\@anthropic-ai/claude-code/vendor/ripgrep/x64-linux/rg'
fi
export PATH=/home/luar/.local/bin\:/.local/pipx/venvs/animdl\:/home/luar/.local/share/ytfzf\:/home/luar/.config/bash/dev-tools/npm/bin\:/home/luar/.config/bash/dev-tools/go/bin\:/home/luar/.config/bash/dev-tools/cargo/bin\:/home/luar/.config/bash/bin\:/home/luar/.local/bin\:/home/luar/.config/bash/modules:\:/bin\:/home/luar/.local/bin\:/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/usr/games\:/usr/local/games\:/snap/bin

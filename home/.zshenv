# ~/.zshenv — sourced by every zsh (interactive or not). Keep it minimal.

# XDG base directories
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

export EDITOR="vim"
export VISUAL="$EDITOR"
export PAGER="less"
export LESS="-R -F -i -M"

# De-duplicated PATH; prepend user bin dirs if they exist
typeset -U path PATH
path=(
  "$HOME/.local/bin"(N)
  "$HOME/bin"(N)
  $path
)
export PATH

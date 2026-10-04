# ~/.zprofile — sourced by login shells, after .zshenv.

# Machine-specific login setup
[[ -r "$HOME/.zprofile.local" ]] && source "$HOME/.zprofile.local"

#!/usr/bin/env bash
# bootstrap.sh — symlink everything under ./home into $HOME, optionally
# install packages and make zsh the login shell.
#
# Usage: ./bootstrap.sh [options]
#   -n, --dry-run     show what would happen, change nothing
#   -p, --packages    apt-install zsh and common tools
#   -s, --shell       change login shell to zsh
#   -a, --all         --packages + --shell + link
#   -h, --help        show this help
#
# Existing files that would be replaced are moved to
# ~/.dotfiles-backup/<timestamp>/ (preserving their relative path).
# Re-running is safe: links that already point to the right place are skipped.

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC_DIR="$DOTFILES_DIR/home"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

DRY_RUN=0
DO_PACKAGES=0
DO_SHELL=0

APT_PACKAGES=(
  zsh zsh-autosuggestions zsh-syntax-highlighting
  git vim tmux curl wget unzip
  fzf ripgrep fd-find bat tree jq htop zoxide
)

if [[ -t 1 ]]; then
  c_blue=$'\e[34m' c_green=$'\e[32m' c_yellow=$'\e[33m' c_red=$'\e[31m' c_reset=$'\e[0m'
else
  c_blue='' c_green='' c_yellow='' c_red='' c_reset=''
fi
info() { printf '%s==>%s %s\n' "$c_blue" "$c_reset" "$*"; }
ok()   { printf '%s ok%s %s\n' "$c_green" "$c_reset" "$*"; }
warn() { printf '%s  !%s %s\n' "$c_yellow" "$c_reset" "$*"; }
die()  { printf '%serror:%s %s\n' "$c_red" "$c_reset" "$*" >&2; exit 1; }

run() {
  if (( DRY_RUN )); then
    printf '   [dry-run] %s\n' "$*"
  else
    "$@"
  fi
}

usage() { sed -n '2,/^$/p' "$0" | sed 's/^# \{0,1\}//'; }

while (( $# )); do
  case "$1" in
    -n|--dry-run)  DRY_RUN=1 ;;
    -p|--packages) DO_PACKAGES=1 ;;
    -s|--shell)    DO_SHELL=1 ;;
    -a|--all)      DO_PACKAGES=1; DO_SHELL=1 ;;
    -h|--help)     usage; exit 0 ;;
    *) usage; die "unknown option: $1" ;;
  esac
  shift
done

install_packages() {
  info "Installing packages via apt"
  command -v apt-get >/dev/null || die "apt-get not found; install packages manually"
  run sudo apt-get update
  run sudo apt-get install -y "${APT_PACKAGES[@]}"
}

link_file() {
  local src="$1" rel="${1#"$SRC_DIR"/}"
  local dest="$HOME/$rel"

  if [[ -L "$dest" && "$(readlink -- "$dest")" == "$src" ]]; then
    ok "$rel (already linked)"
    return
  fi

  if [[ -e "$dest" || -L "$dest" ]]; then
    warn "$rel exists; backing up to $BACKUP_DIR/$rel"
    run mkdir -p "$(dirname -- "$BACKUP_DIR/$rel")"
    run mv -- "$dest" "$BACKUP_DIR/$rel"
  fi

  run mkdir -p "$(dirname -- "$dest")"
  run ln -s -- "$src" "$dest"
  ok "$rel -> $src"
}

link_all() {
  info "Linking dotfiles from $SRC_DIR into $HOME"
  local f
  while IFS= read -r -d '' f; do
    link_file "$f"
  done < <(find "$SRC_DIR" \( -type f -o -type l \) -print0 | sort -z)
}

setup_git_identity() {
  local local_cfg="$HOME/.gitconfig.local"
  [[ -e "$local_cfg" ]] && return
  info "Creating $local_cfg for git identity"
  if [[ -t 0 ]] && (( ! DRY_RUN )); then
    local name email
    read -rp "   git user.name:  " name
    read -rp "   git user.email: " email
    printf '[user]\n\tname = %s\n\temail = %s\n' "$name" "$email" > "$local_cfg"
    ok "wrote $local_cfg"
  else
    warn "non-interactive; create $local_cfg yourself with a [user] section"
  fi
}

change_shell() {
  local zsh_path
  zsh_path="$(command -v zsh || true)"
  if [[ -z "$zsh_path" ]]; then
    warn "zsh not installed; rerun with --packages (or install zsh) before --shell"
    return
  fi
  if [[ "$(getent passwd "$USER" | cut -d: -f7)" == "$zsh_path" ]]; then
    ok "login shell is already $zsh_path"
    return
  fi
  grep -qxF "$zsh_path" /etc/shells || die "$zsh_path is not listed in /etc/shells"
  info "Changing login shell to $zsh_path"
  run chsh -s "$zsh_path"
}

[[ -d "$SRC_DIR" ]] || die "missing $SRC_DIR"
(( DRY_RUN )) && info "Dry run — no changes will be made"

(( DO_PACKAGES )) && install_packages
link_all
setup_git_identity
(( DO_SHELL )) && change_shell

info "Done."
if (( ! DO_SHELL )) && [[ "$(basename -- "${SHELL:-}")" != zsh ]]; then
  echo "   Tip: run './bootstrap.sh --shell' to make zsh your login shell."
fi
if [[ -d "$BACKUP_DIR" ]]; then
  echo "   Replaced files were backed up to $BACKUP_DIR"
fi

# Functions

# mkdir and cd into it
mkcd() { mkdir -p -- "$1" && cd -- "$1"; }

# extract most archive types
extract() {
  if [[ ! -f "$1" ]]; then
    echo "extract: '$1' is not a file" >&2
    return 1
  fi
  case "$1" in
    *.tar.bz2|*.tbz2) tar xjf "$1" ;;
    *.tar.gz|*.tgz)   tar xzf "$1" ;;
    *.tar.xz|*.txz)   tar xJf "$1" ;;
    *.tar.zst)        tar --zstd -xf "$1" ;;
    *.tar)            tar xf "$1" ;;
    *.bz2)            bunzip2 "$1" ;;
    *.gz)             gunzip "$1" ;;
    *.xz)             unxz "$1" ;;
    *.zip)            unzip "$1" ;;
    *.7z)             7z x "$1" ;;
    *) echo "extract: don't know how to extract '$1'" >&2; return 1 ;;
  esac
}

# WSL: open files/URLs with the Windows default handler
if [[ -n "$WSL_DISTRO_NAME" ]]; then
  open() { explorer.exe "${1:-.}"; }
fi

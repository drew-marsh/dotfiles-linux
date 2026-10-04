# ~/.zshrc — interactive shell configuration.

ZSH_CONFIG_DIR="$XDG_CONFIG_HOME/zsh"
mkdir -p "$XDG_STATE_HOME/zsh" "$XDG_CACHE_HOME/zsh"

# --- History -----------------------------------------------------------------
HISTFILE="$XDG_STATE_HOME/zsh/history"
HISTSIZE=50000
SAVEHIST=50000
setopt EXTENDED_HISTORY       # record timestamps
setopt SHARE_HISTORY          # share history across sessions
setopt HIST_IGNORE_DUPS       # skip consecutive duplicates
setopt HIST_IGNORE_ALL_DUPS   # drop older duplicates
setopt HIST_IGNORE_SPACE      # commands starting with a space aren't saved
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY            # show !! expansion before running

# --- General options ---------------------------------------------------------
setopt AUTO_CD                # `dir` alone cds into it
setopt AUTO_PUSHD PUSHD_IGNORE_DUPS PUSHD_SILENT
DIRSTACKSIZE=20
setopt INTERACTIVE_COMMENTS
setopt NO_BEEP
setopt EXTENDED_GLOB
setopt NO_FLOW_CONTROL        # free up ctrl-s / ctrl-q

# --- Completion --------------------------------------------------------------
autoload -Uz compinit
compinit -d "$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"
zmodload zsh/complist

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/zcompcache"
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' squeeze-slashes true

# --- Key bindings ------------------------------------------------------------
bindkey -e                                   # emacs-style line editing
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search   # up: prefix history search
bindkey '^[[B' down-line-or-beginning-search # down
bindkey '^[[H' beginning-of-line             # home
bindkey '^[[F' end-of-line                   # end
bindkey '^[[3~' delete-char                  # delete
bindkey '^[[1;5C' forward-word               # ctrl-right
bindkey '^[[1;5D' backward-word              # ctrl-left
bindkey -M menuselect '^[[Z' reverse-menu-complete  # shift-tab

autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line             # edit command in $EDITOR

# --- Colors ------------------------------------------------------------------
if command -v dircolors >/dev/null; then
  eval "$(dircolors -b)"
fi

# --- Prompt ------------------------------------------------------------------
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr '%F{red}*%f'
zstyle ':vcs_info:*' stagedstr '%F{green}+%f'
zstyle ':vcs_info:git:*' formats ' %F{magenta}%b%f%u%c'
zstyle ':vcs_info:git:*' actionformats ' %F{magenta}%b%f|%F{red}%a%f%u%c'
precmd_functions+=(vcs_info)
setopt PROMPT_SUBST

# user@host only shown over SSH
if [[ -n "$SSH_CONNECTION" ]]; then
  _prompt_host='%F{yellow}%n@%m%f '
fi
PROMPT='${_prompt_host}%F{blue}%~%f${vcs_info_msg_0_}
%(?.%F{green}.%F{red})❯%f '
RPROMPT='%(?..%F{red}%?%f)'

# --- Modules -----------------------------------------------------------------
for _f in "$ZSH_CONFIG_DIR"/*.zsh(N); do
  source "$_f"
done
unset _f

# --- Plugins (installed via apt by bootstrap.sh, optional) -------------------
for _p in \
  /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh \
  /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh; do
  [[ -r "$_p" ]] && source "$_p"
done
unset _p

# fzf key bindings (ctrl-r, ctrl-t, alt-c) if installed
if command -v fzf >/dev/null && fzf --zsh >/dev/null 2>&1; then
  source <(fzf --zsh)
elif [[ -r /usr/share/doc/fzf/examples/key-bindings.zsh ]]; then
  source /usr/share/doc/fzf/examples/key-bindings.zsh
fi

# zoxide: `z <partial>` jumps to frecent dirs, `zi` picks with fzf
if command -v zoxide >/dev/null; then
  eval "$(zoxide init zsh)"
fi

# --- Local overrides (not tracked) -------------------------------------------
[[ -r "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"

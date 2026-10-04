# Aliases

# ls
alias ls='ls --color=auto --group-directories-first'
alias ll='ls -lh'
alias la='ls -lAh'
alias l='ls -CF'

# navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias -- -='cd -'
alias d='dirs -v'

# safety
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -I'
alias mkdir='mkdir -p'

# grep
alias grep='grep --color=auto'

# misc
alias h='history 1'
alias path='print -l $path'
alias reload='exec zsh'
alias df='df -h'
alias du='du -h'
alias free='free -h'

# git
alias g='git'
alias gs='git status -sb'
alias ga='git add'
alias gc='git commit'
alias gd='git diff'
alias gds='git diff --staged'
alias gl='git lg'
alias gp='git push'
alias gpl='git pull'
alias gco='git checkout'
alias gsw='git switch'

# Ubuntu ships these under different names
command -v batcat >/dev/null && ! command -v bat >/dev/null && alias bat='batcat'
command -v fdfind >/dev/null && ! command -v fd >/dev/null && alias fd='fdfind'

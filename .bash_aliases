# ==============================================================================
# 1. CORE UTILITIES & SAFETY
# ==============================================================================
# Safety nets for destructive commands
alias rm='rm -I' # Prompts if deleting >3 files or recursively
alias cp='cp -i'
alias mv='mv -i'

# Easy navigation
alias ..='cd ..'
alias ...='cd ../..'

# Modern 'ls' replacement (eza) with fallback to default 'ls'
if command -v eza &> /dev/null; then
    alias ls='eza --icons --group-directories-first'
    alias ll='eza -alF --icons --group-directories-first'
    alias la='eza -a --icons --group-directories-first'
    alias l='eza -F --icons'
elif [ -x /usr/bin/dircolors ]; then
    # Fallback standard Ubuntu color support
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    
    alias ll='ls -alF'
    alias la='ls -A'
    alias l='ls -CF'
fi

# ==============================================================================
# 2. EDITOR SETUP (Portable Neovim)
# ==============================================================================
# Only alias vi/vim to nvim if nvim is actually installed on this system
if command -v nvim &> /dev/null; then
    alias vim='nvim'
    alias vi='nvim'
fi

# ==============================================================================
# 3. GIT & WORKFLOW SHORTCUTS
# ==============================================================================
# Bare repo dotfiles manager
alias config="/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME"

# Jira integration
alias myissues='jira issue list -s"Open" -s"In Progress" -s"Reviewing" -a$(jira me)'

# Python/Environment workflow
alias venv="source .venv/bin/activate"
alias uvj="uv run --with jupyter jupyter lab"
alias update_repo="git pull && pip install -r requirements.txt && pip install -e ."

# Misc Utilities
alias si="~/bin/info2.sh"

# Alert for long running commands (e.g. `sleep 10; alert`)
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

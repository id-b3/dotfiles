# ==============================================================================
# 1. INITIALIZATION & SAFETY CHECKS
# ==============================================================================
# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# ==============================================================================
# 2. HISTORY MANAGEMENT (Developer Optimized)
# ==============================================================================
# Ignore duplicate commands and commands starting with a space
HISTCONTROL=ignoreboth:erasedups

# Massive history limits (Text is cheap, lost commands are expensive)
HISTSIZE=100000
HISTFILESIZE=100000

# Append to the history file, don't overwrite it
shopt -s histappend
# Save multi-line commands as one line
shopt -s cmdhist

# Instantly sync history across multiple terminal tabs/tmux panes
export PROMPT_COMMAND="history -a; history -n; ${PROMPT_COMMAND:-}"
# PROMPT_COMMAND="history -a; history -c; history -r; ${PROMPT_COMMAND:+$PROMPT_COMMAND}"

# ==============================================================================
# 3. SHELL OPTIONS (Quality of Life)
# ==============================================================================
# Check window size after each command to update LINES and COLUMNS
shopt -s checkwinsize
# Enable ** recursive globbing (e.g., ls **/*.js)
shopt -s globstar
# Auto-change directory if you just type a path
shopt -s autocd
# Auto-correct minor typos in directory names
shopt -s cdspell
shopt -s dirspell

# Make less more friendly for non-text input files
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# ==============================================================================
# 4. DEFAULT PROMPT FALLBACK
# ==============================================================================
# This acts as a reliable fallback. We will try to override this with 
# ~/.bash_prompt later down the file.
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Detect color support safely
if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi

# Set xterm title to user@host:dir
case "$TERM" in
    xterm*|rxvt*) PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1" ;;
esac

# ==============================================================================
# 5. MODULAR SOURCING (Aliases, Exports, Prompt, Secrets)
# ==============================================================================
# Loop through our modular dotfiles and source them conditionally if they exist
for file in ~/.bash_exports ~/.bash_aliases ~/.secrets ~/.bash_prompt ~/.bash_local; do
    [ -f "$file" ] && source "$file"
done

# ==============================================================================
# 6. AUTOCOMPLETION
# ==============================================================================
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# ==============================================================================
# 7. TOOLCHAIN INITIALIZATION (Portable)
# ==============================================================================

# Rust / Cargo
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

# FNM (Fast Node Manager)
FNM_PATH="$HOME/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
fi
# Only evaluate fnm if the command actually exists on this machine
if command -v fnm &> /dev/null; then
  eval "$(fnm env)"
fi

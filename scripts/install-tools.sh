#!/usr/bin/env bash
# ==============================================================================
# install-tools.sh — One-shot environment bootstrap
#
# Installs development tools to $HOME/.local/ (no sudo needed for the tools
# themselves).  Can optionally use sudo for system dependencies (curl, build
# tools, etc.) via the --sudo flag.
#
# Usage:
#   ./install-tools.sh                          # install everything (no sudo)
#   ./install-tools.sh --sudo                   # install everything + sudo deps
#   ./install-tools.sh --sudo neovim uv         # only neovim + uv with sudo
#   ./install-tools.sh list                     # show available tools
#
# Each tool function is individually callable after sourcing:
#   source ./install-tools.sh
#   install_neovim
#   install_neovim --sudo
# ==============================================================================

set -euo pipefail

# ── Constants ─────────────────────────────────────────────────────────────────
BIN_DIR="$HOME/.local/bin"
OPT_DIR="$HOME/.local/opt"
EXPORT_FILE="$HOME/.bash_exports"
BASHRC="$HOME/.bashrc"
BASH_PROMPT="$HOME/.bash_prompt"

# ── Colors ────────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

info()  { printf "${BLUE}[info]${NC}  %s\n" "$*"; }
ok()    { printf "${GREEN}[ ok ]${NC}  %s\n" "$*"; }
warn()  { printf "${YELLOW}[warn]${NC}  %s\n" "$*"; }
err()   { printf "${RED}[err]${NC}   %s\n" "$*" >&2; }

# ── Helpers ───────────────────────────────────────────────────────────────────

# Idempotent append: only appends $2 to $1 if $2 is not already present.
__append_line() {
    local file="$1" line="$2"
    grep -qsF "$line" "$file" 2>/dev/null && return 0
    echo "$line" >> "$file"
    return 0
}

# Detect package manager → install command
__sudo_install() {
    local pkg="$1"
    if command -v apt-get &>/dev/null; then
        sudo apt-get update -qq && sudo apt-get install -y -qq "$pkg"
    elif command -v apt &>/dev/null; then
        sudo apt update -qq && sudo apt install -y -qq "$pkg"
    elif command -v dnf &>/dev/null; then
        sudo dnf install -y "$pkg"
    elif command -v yum &>/dev/null; then
        sudo yum install -y "$pkg"
    elif command -v pacman &>/dev/null; then
        sudo pacman -S --noconfirm "$pkg"
    elif command -v zypper &>/dev/null; then
        sudo zypper install -y "$pkg"
    elif command -v apk &>/dev/null; then
        sudo apk add "$pkg"
    else
        err "No supported package manager found (apt, dnf, yum, pacman, zypper, apk)"
        return 1
    fi
}

__sudo_install_group() {
    if command -v apt-get &>/dev/null || command -v apt &>/dev/null; then
        sudo apt-get update -qq
        sudo apt-get install -y -qq build-essential curl
    elif command -v dnf &>/dev/null; then
        sudo dnf groupinstall -y "Development Tools"
        sudo dnf install -y curl
    elif command -v pacman &>/dev/null; then
        sudo pacman -Sy --noconfirm base-devel curl
    elif command -v zypper &>/dev/null; then
        sudo zypper install -y -t pattern devel_basis
        sudo zypper install -y curl
    elif command -v apk &>/dev/null; then
        sudo apk add build-base curl
    else
        err "No supported package manager found"
        return 1
    fi
}

# ── Tool 1: Neovim ────────────────────────────────────────────────────────────

install_neovim() {
    local _use_sudo=false

    for _arg in "$@"; do
        case "$_arg" in
            --sudo) _use_sudo=true ;;
            *)
                err "install_neovim: unknown option '$_arg'"
                echo "Usage: install_neovim [--sudo]" >&2
                return 1
                ;;
        esac
    done

    # Idempotency
    if [ -x "$BIN_DIR/nvim" ]; then
        ok "Neovim already installed at $BIN_DIR/nvim — skipping."
        return 0
    fi

    # System deps
    if [ "$_use_sudo" = true ]; then
        info "installing system build dependencies ..."
        __sudo_install_group
    fi

    # Require curl
    if ! command -v curl &>/dev/null; then
        err "curl is required. Re-run with --sudo or install curl manually."
        return 1
    fi

    # Detect architecture
    local _arch _tarball
    _arch="$(uname -m)"
    case "$_arch" in
        x86_64)  _tarball="nvim-linux-x86_64.tar.gz"  ;;
        aarch64) _tarball="nvim-linux-arm64.tar.gz"   ;;
        *)
            err "unsupported architecture '${_arch}' (expected x86_64 or aarch64)"
            return 1
            ;;
    esac

    # Resolve latest release tag
    local _latest_url _version
    _latest_url="$(
        curl -fsS -o /dev/null -w '%{redirect_url}' \
            "https://github.com/neovim/neovim/releases/latest"
    )" || {
        err "failed to resolve latest release URL"
        return 1
    }
    _version="${_latest_url##*/}"

    mkdir -p "$OPT_DIR" "$BIN_DIR"

    local _target_dir="$OPT_DIR/neovim"
    local _dl_url="https://github.com/neovim/neovim/releases/download/${_version}/${_tarball}"
    local _tmpdir
    _tmpdir="$(mktemp -d)"

    info "downloading Neovim ${_version} ..."
    curl -fsSL "$_dl_url" -o "$_tmpdir/$_tarball" || {
        err "download failed"
        rm -rf "$_tmpdir"
        return 1
    }

    info "extracting to ${_target_dir} ..."
    rm -rf "$_target_dir"
    mkdir -p "$_target_dir"
    tar -xzf "$_tmpdir/$_tarball" -C "$_tmpdir"

    local _stem="${_tarball%.tar.gz}"
    mv "$_tmpdir/$_stem/"* "$_target_dir/"
    rm -rf "$_tmpdir"

    # Symlink
    ln -sf "$_target_dir/bin/nvim" "$BIN_DIR/nvim"

    # PATH registration in .bash_exports
    if ! grep -qs '\.local/opt/neovim/bin' "$EXPORT_FILE" 2>/dev/null; then
        {
            echo ""
            echo "# Neovim (added by install-tools.sh)"
            echo "export PATH=\"\$HOME/.local/opt/neovim/bin:\$PATH\""
        } >> "$EXPORT_FILE"
        info "added neovim to PATH in ${EXPORT_FILE}"
    fi

    ok "Neovim ${_version} installed"
    echo "  Binary:   $BIN_DIR/nvim"
    echo "  Location: $_target_dir"
}

# ── Tool 2: Starship ─────────────────────────────────────────────────────────

install_starship() {
    local _use_sudo=false

    for _arg in "$@"; do
        case "$_arg" in
            --sudo) _use_sudo=true ;;
            *)
                err "install_starship: unknown option '$_arg'"
                echo "Usage: install_starship [--sudo]" >&2
                return 1
                ;;
        esac
    done

    # Idempotency
    if [ -x "$BIN_DIR/starship" ]; then
        ok "Starship already installed at $BIN_DIR/starship — skipping."
        __starship_ensure_init
        return 0
    fi

    # System deps
    if [ "$_use_sudo" = true ]; then
        info "installing curl via package manager ..."
        __sudo_install curl
    fi

    if ! command -v curl &>/dev/null; then
        err "curl is required. Re-run with --sudo or install curl manually."
        return 1
    fi

    mkdir -p "$BIN_DIR"

    info "downloading Starship installer ..."
    curl -fsS https://starship.rs/install.sh | sh -s -- -y -b "$BIN_DIR" || {
        err "Starship installation failed"
        return 1
    }

    if [ ! -x "$BIN_DIR/starship" ]; then
        err "Starship binary not found after install"
        return 1
    fi

    __starship_ensure_init
    ok "Starship installed at $BIN_DIR/starship"
}

__starship_ensure_init() {
    # Check .bash_prompt first (preferred location) — if it already has
    # starship init, we're done. Otherwise check & fix .bashrc.
    if grep -qs 'starship init bash' "$BASH_PROMPT" 2>/dev/null; then
        return 0
    fi
    if grep -qs 'starship init bash' "$BASHRC" 2>/dev/null; then
        return 0
    fi
    # Append to .bash_prompt (it's the proper prompt config file)
    {
        echo ""
        echo "# Starship prompt (added by install-tools.sh)"
        echo "if command -v \"\$HOME/.local/bin/starship\" >/dev/null 2>&1; then"
        echo "    eval -- \"\$(\"\$HOME/.local/bin/starship\" init bash)\""
        echo "    return"
        echo "elif command -v starship >/dev/null 2>&1; then"
        echo "    eval -- \"\$(starship init bash)\""
        echo "    return"
        echo "fi"
    } >> "$BASH_PROMPT"
    info "added starship init to ${BASH_PROMPT}"
}

# ── Tool 3: fnm (Fast Node Manager) ──────────────────────────────────────────

install_fnm() {
    local _use_sudo=false

    for _arg in "$@"; do
        case "$_arg" in
            --sudo) _use_sudo=true ;;
            *)
                err "install_fnm: unknown option '$_arg'"
                echo "Usage: install_fnm [--sudo]" >&2
                return 1
                ;;
        esac
    done

    local _fnm_bin="${HOME}/.local/share/fnm/fnm"

    # System deps
    if [ "$_use_sudo" = true ]; then
        info "installing curl via package manager ..."
        __sudo_install curl
    fi

    if ! command -v curl &>/dev/null; then
        err "curl is required. Re-run with --sudo or install curl manually."
        return 1
    fi

    # Install fnm binary
    if [ -x "$_fnm_bin" ]; then
        ok "fnm already installed at ${_fnm_bin}"
    else
        info "downloading fnm installer ..."
        curl -fsSL https://fnm.vercel.app/install | bash || {
            err "fnm installation failed"
            return 1
        }
        ok "fnm installed"
    fi

    # Ensure fnm env is sourced in .bashrc
    if ! grep -qs 'fnm env' "$BASHRC" 2>/dev/null; then
        {
            echo ""
            echo "# fnm (Fast Node Manager) – added by install-tools.sh"
            echo "FNM_PATH=\"\$HOME/.local/share/fnm\""
            echo "if [ -d \"\$FNM_PATH\" ]; then"
            echo "  export PATH=\"\$FNM_PATH:\$PATH\""
            echo "  if command -v fnm &> /dev/null; then"
            echo '    eval "$(fnm env)"'
            echo "  fi"
            echo "fi"
        } >> "$BASHRC"
        info "added fnm env to ${BASHRC}"
    fi

    # Source fnm for the current session
    export PATH="${HOME}/.local/share/fnm:$PATH"
    eval "$(fnm env 2>/dev/null)" || true

    # Install latest LTS Node.js
    info "installing latest LTS Node.js via fnm ..."
    fnm install --lts

    # Set as default
    local _default
    _default="$(fnm default 2>/dev/null || true)"
    if [ "$_default" != "lts" ]; then
        fnm default lts
        info "set LTS as default Node.js version"
    fi

    ok "fnm ready — Node.js $(node --version 2>/dev/null || echo '(start a new shell)')"
}

# ── Tool 4: uv (Python manager) ──────────────────────────────────────────────

install_uv() {
    local _use_sudo=false

    for _arg in "$@"; do
        case "$_arg" in
            --sudo) _use_sudo=true ;;
            *)
                err "install_uv: unknown option '$_arg'"
                echo "Usage: install_uv [--sudo]" >&2
                return 1
                ;;
        esac
    done

    # Idempotency
    if command -v uv &>/dev/null && uv --version &>/dev/null 2>&1; then
        ok "uv already installed ($(uv --version)) — skipping."
        __uv_ensure_completion
        return 0
    fi

    # System deps
    if [ "$_use_sudo" = true ]; then
        info "installing curl via package manager ..."
        __sudo_install curl
    fi

    if ! command -v curl &>/dev/null; then
        err "curl is required. Re-run with --sudo or install curl manually."
        return 1
    fi

    info "downloading uv installer ..."
    curl -LsSf https://astral.sh/uv/install.sh | sh || {
        err "uv installation failed"
        return 1
    }

    # Ensure ~/.local/bin is on PATH
    export PATH="$HOME/.local/bin:$PATH"

    if ! command -v uv &>/dev/null; then
        err "uv binary not found after install"
        return 1
    fi

    ok "uv installed ($(uv --version))"

    # Install latest Python
    info "installing latest Python via uv ..."
    uv python install || warn "uv python install failed (non-fatal)"

    __uv_ensure_completion
}

__uv_ensure_completion() {
    local _marker="# uv shell completion (added by install-tools.sh)"
    if grep -qsF "$_marker" "$BASHRC" 2>/dev/null; then
        return 0
    fi
    {
        echo ""
        echo "$_marker"
        echo 'if command -v uv &>/dev/null; then'
        echo '  eval "$(uv generate-shell-completion bash)"'
        echo 'fi'
    } >> "$BASHRC"
    info "added uv shell completion to ${BASHRC}"
}

# ── Main CLI ──────────────────────────────────────────────────────────────────

AVAILABLE_TOOLS="neovim starship fnm uv"

usage() {
    cat <<EOF
Usage: $(basename "$0") [--sudo] [tool ...]

Install development tools to \$HOME/.local (no sudo for tools themselves).

Options:
  --sudo       Use sudo for system dependencies (curl, build tools, etc.)
  list         Show available tools
  help         Show this help message

Tools (install all if none specified):
EOF
    for t in $AVAILABLE_TOOLS; do
        echo "  • $t"
    done
}

main() {
    local use_sudo=false
    local tools=()

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --sudo) use_sudo=true; shift ;;
            list)
                echo "Available tools: $AVAILABLE_TOOLS"
                return 0
                ;;
            help|-h|--help)
                usage
                return 0
                ;;
            *)
                tools+=("$1")
                shift
                ;;
        esac
    done

    # If no tools specified, install all
    if [[ ${#tools[@]} -eq 0 ]]; then
        tools=($AVAILABLE_TOOLS)
    fi

    local sudo_flag=""
    $use_sudo && sudo_flag="--sudo"

    # Ensure target directories exist
    mkdir -p "$BIN_DIR" "$OPT_DIR"

    for tool in "${tools[@]}"; do
        case "$tool" in
            neovim)
                echo ""
                info "=== Installing Neovim ==="
                install_neovim $sudo_flag
                ;;
            starship)
                echo ""
                info "=== Installing Starship ==="
                install_starship $sudo_flag
                ;;
            fnm)
                echo ""
                info "=== Installing fnm ==="
                install_fnm $sudo_flag
                ;;
            uv)
                echo ""
                info "=== Installing uv ==="
                install_uv $sudo_flag
                ;;
            *)
                err "unknown tool: $tool"
                echo "Available: $AVAILABLE_TOOLS"
                return 1
                ;;
        esac
    done

    echo ""
    ok "Installation complete!"
    echo ""
    echo "To activate the tools in your current shell, run:"
    echo "  source $BASHRC"
    echo "  source $EXPORT_FILE"
    echo ""
    echo "Or simply start a new terminal session."
}

# Allow sourcing (functions only) or direct execution
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi

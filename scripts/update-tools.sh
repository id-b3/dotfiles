#!/usr/bin/env bash
# ==============================================================================
# update-tools.sh — Update previously installed tools to latest versions.
#
# Usage:
#   ./update-tools.sh                          # update everything
#   ./update-tools.sh neovim uv                # only neovim + uv
#   ./update-tools.sh --sudo                   # update everything + sudo deps
#   ./update-tools.sh list                     # show available tools
#
# Each tool function is individually callable after sourcing:
#   source ./update-tools.sh
#   update_neovim
# ==============================================================================

set -euo pipefail

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

BIN_DIR="$HOME/.local/bin"
OPT_DIR="$HOME/.local/opt"

# ── Neovim update ─────────────────────────────────────────────────────────────

update_neovim() {
    local _arch _tarball
    _arch="$(uname -m)"
    case "$_arch" in
        x86_64)  _tarball="nvim-linux-x86_64.tar.gz"  ;;
        aarch64) _tarball="nvim-linux-arm64.tar.gz"   ;;
        *)       err "unsupported architecture"; return 1 ;;
    esac

    if ! command -v curl &>/dev/null; then
        err "curl is required"
        return 1
    fi

    # Resolve latest release tag
    local _latest_url _version
    _latest_url="$(
        curl -fsS -o /dev/null -w '%{redirect_url}' \
            "https://github.com/neovim/neovim/releases/latest"
    )" || { err "failed to resolve latest release"; return 1; }
    _version="${_latest_url##*/}"

    # Detect current version
    local _current=""
    if command -v nvim &>/dev/null; then
        _current="$(nvim --version 2>/dev/null | head -1 | grep -oP 'v?\d+\.\d+\.\d+' || true)"
    fi

    if [ "$_current" = "$_version" ]; then
        ok "Neovim already at latest version ${_version}"
        return 0
    fi

    info "Updating Neovim: ${_current:-none} → ${_version}"

    local _target_dir="$OPT_DIR/neovim"
    local _dl_url="https://github.com/neovim/neovim/releases/download/${_version}/${_tarball}"
    local _tmpdir
    _tmpdir="$(mktemp -d)"

    info "downloading ${_version} ..."
    curl -fsSL "$_dl_url" -o "$_tmpdir/$_tarball" || {
        err "download failed"
        rm -rf "$_tmpdir"
        return 1
    }

    info "extracting ..."
    rm -rf "$_target_dir"
    mkdir -p "$_target_dir"
    tar -xzf "$_tmpdir/$_tarball" -C "$_tmpdir"
    local _stem="${_tarball%.tar.gz}"
    mv "$_tmpdir/$_stem/"* "$_target_dir/"
    rm -rf "$_tmpdir"

    ok "Neovim updated to ${_version}"
}

# ── Starship update ───────────────────────────────────────────────────────────

update_starship() {
    if ! command -v starship &>/dev/null; then
        err "Starship not installed. Run install-tools.sh first."
        return 1
    fi

    local _current
    _current="$(starship --version 2>/dev/null | head -1)"

    info "Updating Starship (current: ${_current:-unknown}) ..."
    curl -fsS https://starship.rs/install.sh | sh -s -- -y -b "$BIN_DIR" || {
        err "Starship update failed"
        return 1
    }

    ok "Starship updated ($(starship --version 2>/dev/null | head -1))"
}

# ── fnm update ────────────────────────────────────────────────────────────────

update_fnm() {
    if ! command -v fnm &>/dev/null; then
        err "fnm not installed. Run install-tools.sh first."
        return 1
    fi

    local _current
    _current="$(fnm --version 2>/dev/null)"

    info "Updating fnm (current: ${_current:-unknown}) ..."

    # fnm install script is idempotent for the binary
    curl -fsSL https://fnm.vercel.app/install | bash || {
        err "fnm update failed"
        return 1
    }

    ok "fnm updated ($(fnm --version 2>/dev/null))"

    # Update LTS Node.js
    info "updating LTS Node.js ..."
    eval "$(fnm env 2>/dev/null)" || true
    fnm install --lts
    fnm default lts

    ok "Node.js LTS updated ($(node --version 2>/dev/null))"
}

# ── uv update ─────────────────────────────────────────────────────────────────

update_uv() {
    if ! command -v uv &>/dev/null; then
        err "uv not installed. Run install-tools.sh first."
        return 1
    fi

    local _current
    _current="$(uv --version 2>/dev/null)"

    info "Updating uv (current: ${_current}) ..."
    uv self update || {
        # Fallback: re-run installer
        warn "uv self update failed, re-running installer ..."
        curl -LsSf https://astral.sh/uv/install.sh | sh || {
            err "uv update failed"
            return 1
        }
    }

    ok "uv updated ($(uv --version 2>/dev/null))"

    # Update Python
    info "updating Python ..."
    uv python install || warn "uv python install failed (non-fatal)"
}

# ── Main CLI ──────────────────────────────────────────────────────────────────

AVAILABLE_TOOLS="neovim starship fnm uv"

usage() {
    cat <<EOF
Usage: $(basename "$0") [tool ...]

Update previously installed tools to their latest versions.
Run install-tools.sh first if tools aren't installed yet.

Options:
  list         Show available tools
  help         Show this help message
EOF
}

main() {
    local tools=()

    while [[ $# -gt 0 ]]; do
        case "$1" in
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

    if [[ ${#tools[@]} -eq 0 ]]; then
        tools=($AVAILABLE_TOOLS)
    fi

    for tool in "${tools[@]}"; do
        case "$tool" in
            neovim)
                echo ""
                info "=== Updating Neovim ==="
                update_neovim
                ;;
            starship)
                echo ""
                info "=== Updating Starship ==="
                update_starship
                ;;
            fnm)
                echo ""
                info "=== Updating fnm ==="
                update_fnm
                ;;
            uv)
                echo ""
                info "=== Updating uv ==="
                update_uv
                ;;
            *)
                err "unknown tool: $tool"
                echo "Available: $AVAILABLE_TOOLS"
                return 1
                ;;
        esac
    done

    echo ""
    ok "All updates complete!"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi

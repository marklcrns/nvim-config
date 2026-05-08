#!/usr/bin/env bash
# install.sh — Install all dependencies for this Neovim config
# Supports: macOS (Homebrew), Debian/Ubuntu, Arch, Fedora/RHEL, Alpine, WSL2

set -euo pipefail

SCRIPTDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPTDIR/format.sh"

# ─── Detect platform ──────────────────────────────────────────────────────────

OS="$(uname -s)"
IS_WSL=false
if [[ "$OS" == "Linux" ]] && grep -qiE "(microsoft|WSL)" /proc/version 2>/dev/null; then
  IS_WSL=true
fi

pkg_install() {
  # Usage: pkg_install <pkg-apt> [pkg-brew] [pkg-pacman] [pkg-dnf] [pkg-apk]
  local apt_pkg="${1:-}"
  local brew_pkg="${2:-$apt_pkg}"
  local pacman_pkg="${3:-$apt_pkg}"
  local dnf_pkg="${4:-$apt_pkg}"
  local apk_pkg="${5:-$apt_pkg}"

  if [[ "$OS" == "Darwin" ]]; then
    brew install "$brew_pkg" 2>/dev/null || true
  elif command -v apt-get &>/dev/null; then
    sudo apt-get install -y "$apt_pkg"
  elif command -v pacman &>/dev/null; then
    sudo pacman -S --noconfirm "$pacman_pkg"
  elif command -v dnf &>/dev/null; then
    sudo dnf install -y "$dnf_pkg"
  elif command -v apk &>/dev/null; then
    sudo apk add "$apk_pkg"
  else
    warn "Unknown package manager — please install '$apt_pkg' manually"
  fi
}

# ─── Neovim ───────────────────────────────────────────────────────────────────

action "Checking Neovim (>= 0.10 required)"
if ! command -v nvim &>/dev/null; then
  if [[ "$OS" == "Darwin" ]]; then
    brew install neovim
  elif command -v apt-get &>/dev/null; then
    # Use official AppImage or PPA for latest stable
    sudo add-apt-repository -y ppa:neovim-ppa/stable 2>/dev/null || true
    sudo apt-get update -y
    sudo apt-get install -y neovim
  elif command -v pacman &>/dev/null; then
    sudo pacman -S --noconfirm neovim
  elif command -v dnf &>/dev/null; then
    sudo dnf install -y neovim
  else
    error "Neovim not found. Install from https://github.com/neovim/neovim/releases"
    exit 1
  fi
fi
ok "Neovim: $(nvim --version | head -1)"

# ─── Core CLI tools ───────────────────────────────────────────────────────────

action "Installing core CLI tools"

# git
if ! command -v git &>/dev/null; then
  pkg_install git
fi
ok "git: $(git --version)"

# ripgrep (telescope grep)
if ! command -v rg &>/dev/null; then
  pkg_install ripgrep ripgrep ripgrep ripgrep ripgrep
fi
ok "ripgrep: $(rg --version | head -1)"

# fd (telescope file finder)
if ! command -v fd &>/dev/null; then
  pkg_install fd-find fd fd fd-find fd
  # Debian installs as fdfind
  if command -v fdfind &>/dev/null && ! command -v fd &>/dev/null; then
    mkdir -p "$HOME/.local/bin"
    ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
    export PATH="$HOME/.local/bin:$PATH"
  fi
fi
ok "fd: $(fd --version 2>/dev/null || fdfind --version)"

# curl
if ! command -v curl &>/dev/null; then
  pkg_install curl
fi

# ─── Node.js ──────────────────────────────────────────────────────────────────

action "Checking Node.js (required for LSP servers)"
if ! command -v node &>/dev/null; then
  error "Node.js not found."
  warn "Install via: https://nodejs.org or 'brew install node' or 'nvm install --lts'"
  exit 1
fi
ok "node: $(node --version)"

# neovim npm package (node provider)
if ! node -e "require('neovim')" 2>/dev/null; then
  running "Installing neovim npm package"
  npm install -g neovim
fi
ok "neovim npm package installed"

# ─── Python ───────────────────────────────────────────────────────────────────

action "Setting up Python provider"
if ! command -v python3 &>/dev/null; then
  error "python3 not found. Please install Python 3."
  exit 1
fi
ok "python3: $(python3 --version)"

source "$SCRIPTDIR/generate_venv.sh"

# ─── Rust / Cargo (blink.cmp build) ──────────────────────────────────────────

action "Checking Rust/Cargo (required for blink.cmp)"
if ! command -v cargo &>/dev/null; then
  running "Installing Rust via rustup"
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
  source "$HOME/.cargo/env"
fi
ok "cargo: $(cargo --version)"

# ─── Clipboard ────────────────────────────────────────────────────────────────

action "Checking clipboard support"
if [[ "$OS" == "Darwin" ]]; then
  ok "macOS: pbcopy/pbpaste available"
elif [[ "$IS_WSL" == "true" ]]; then
  ok "WSL2: win32yank or clip.exe available"
elif [[ "$OS" == "Linux" ]]; then
  if ! command -v xclip &>/dev/null && ! command -v xsel &>/dev/null && ! command -v wl-copy &>/dev/null; then
    running "Installing xclip for clipboard support"
    pkg_install xclip xclip xclip xclip xclip
  fi
  ok "Clipboard tool available"
fi

# ─── Optional tools ───────────────────────────────────────────────────────────

action "Installing optional tools"

# tree-sitter CLI (for :TSInstallFromGrammar)
if ! command -v tree-sitter &>/dev/null; then
  running "Installing tree-sitter-cli"
  npm install -g tree-sitter-cli
fi
ok "tree-sitter: $(tree-sitter --version 2>/dev/null || echo 'installed')"

# stylua (Lua formatter, used by conform.nvim)
if ! command -v stylua &>/dev/null; then
  if [[ "$OS" == "Darwin" ]]; then
    brew install stylua
  elif command -v cargo &>/dev/null; then
    cargo install stylua
  else
    warn "stylua not installed — install from https://github.com/JohnnyMorganz/StyLua/releases"
  fi
fi
command -v stylua &>/dev/null && ok "stylua: $(stylua --version)"

# lazygit (optional, used by snacks.lazygit)
if ! command -v lazygit &>/dev/null; then
  if [[ "$OS" == "Darwin" ]]; then
    brew install lazygit
  else
    warn "lazygit not installed (optional) — install from https://github.com/jesseduffield/lazygit"
  fi
fi
command -v lazygit &>/dev/null && ok "lazygit: $(lazygit --version 2>/dev/null | head -1)"

# luarocks (optional, for some plugins)
if ! command -v luarocks &>/dev/null; then
  pkg_install luarocks luarocks luarocks luarocks luarocks
fi
command -v luarocks &>/dev/null && ok "luarocks: $(luarocks --version | head -1)"

# ─── Done ─────────────────────────────────────────────────────────────────────

echo ""
ok "======================================================"
ok " Installation complete!"
ok " Open Neovim and run :Lazy sync to install plugins."
ok "======================================================"

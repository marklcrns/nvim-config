#!/usr/bin/env bash
# generate_venv.sh — Set up Python 3 virtual environment for Neovim provider

set -euo pipefail

SCRIPTDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPTDIR/format.sh"

DATA_PATH="${HOME}/.cache/vim"

action "Setting up Python 3 provider venv"

if ! command -v python3 &>/dev/null; then
  error "python3 not found. Please install Python 3."
  exit 1
fi

VENV_DIR="${DATA_PATH}/venv/python3/env"
mkdir -p "${DATA_PATH}/venv/python3"

if [[ ! -d "$VENV_DIR" ]]; then
  running "Creating venv at $VENV_DIR"
  python3 -m venv "$VENV_DIR"
fi

running "Installing/upgrading Python packages"
"$VENV_DIR/bin/pip" install --upgrade pip --quiet
"$VENV_DIR/bin/pip" install --upgrade \
  pynvim \
  neovim-remote \
  PyYAML \
  Send2Trash \
  --quiet

ok "Python 3 provider ready: $("$VENV_DIR/bin/python3" --version)"
ok "pynvim: $("$VENV_DIR/bin/pip" show pynvim 2>/dev/null | grep Version | awk '{print $2}')"

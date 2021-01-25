#!/bin/bash

# Install script to install all thinkvim dependencies

set -e

SCRIPTPATH="$(realpath -s $0)"
SCRIPTDIR=$(dirname ${SCRIPTPATH})
NVIM_ROOT="$(realpath "${SCRIPTDIR}/..")"

# Install Neovim latest if not already
if ! command -v nvim &> /dev/null; then
  pkg install nvim
fi

if ! command -v python &> /dev/null; then
  pkg install python
  pip install neovim
  pip install virtualenv
else
  pip install neovim
  pip install virtualenv
fi

if ! command -v npm &> /dev/null; then
  pkg install nodejs
  npm install -g neovim
else
  npm install -g neovim
fi

if ! command -v fzf &> /dev/null; then
  pkg install fzf
fi

if ! command -v rg &> /dev/null; then
  pkg install ripgrep
fi

if ! command -v task &> /dev/null; then
  pkg install taskwarrior
fi

# Generate virtual environment for vim python prog host
source ${SCRIPTDIR}/generate_venv.sh

echo
echo "Done!"

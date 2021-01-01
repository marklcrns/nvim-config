#!/bin/bash

# Install script to install all thinkvim dependencies

set -e

SCRIPTPATH="$(realpath -s $0)"
SCRIPTDIR=$(dirname ${SCRIPTPATH})
NVIM_ROOT="$(realpath "${SCRIPTDIR}/..")"

# Install Neovim latest if not already
if ! command -v nvim &> /dev/null; then
  sudo add-apt-repository ppa:neovim-ppa/unstable -y
  sudo apt-get update -y
  sudo apt install neovim -y
fi

if ! command -v fzf &> /dev/null; then
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install
fi

# Clipboard support
sudo apt install xclip
# For GUI prompts, VCoolor.vim and other support
sudo apt install yad zenity zeal -y
# Taskwarrior
sudo apt install taskwarrior -y
# C/C++ language server for coc (Debian based and Ubuntu 20.04 only)
sudo apt install ccls -y

# Install virtual environment for vim python prog host
source ${SCRIPTDIR}/venv.sh

# python2 host prog
if source ${NVIM_ROOT}/env/python/env/bin/activate; then
  pip install wheel pynvim neovim
  # Optionals
  pip install git+git://github.com/tbabej/tasklib@develop # For tbabej/taskwiki
  pip install six
  pip install keyring browser_cookie3  # for leetcode.vim
  pip install keyrings.alt
  deactivate
fi

# python3 host prog
if source ${NVIM_ROOT}/env/python3/env/bin/activate; then
  pip install wheel pynvim neovim
  # Optionals
  pip install git+git://github.com/tbabej/tasklib@develop # For tbabej/taskwiki
  pip install six
  pip install keyring browser_cookie3  # for leetcode.vim
  pip install keyrings.alt
  deactivate
fi

# Npm packages for linking and formatter
if command -v npm &> /dev/null; then
  npm install -g eslint stylelint prettier
else
  echo
  echo "Error: npm package manager not found... SKIPPING"
  echo
fi

echo
echo "Done!"

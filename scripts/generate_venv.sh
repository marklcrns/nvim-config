#!/bin/bash

# Install script to install virtual environment for vim python prog hosts

set -e

SCRIPTPATH="$(realpath -s $0)"
SCRIPTDIR=$(dirname ${SCRIPTPATH})
DATA_PATH="${HOME}/.cache/vim"

source $SCRIPTDIR/format.sh

action "Setting up python provider"

# python2 host prog
if command -v python2 &> /dev/null; then
  mkdir -p ${DATA_PATH}/venv/python
  if command -v virtualenv &> /dev/null; then
    virtualenv --python=python2 ${DATA_PATH}/venv/python/env
  else
    python -m venv ${DATA_PATH}/venv/python/env
  fi

  # Install pip2 packages
  if source ${DATA_PATH}/venv/python/env/bin/activate; then
    pip install wheel neovim PyYAML Send2Trash
    # Optionals
    pip install git+git://github.com/tbabej/tasklib@develop # For tbabej/taskwiki
    pip install six
    pip install keyring browser_cookie3  # for leetcode.vim
    pip install keyrings.alt
    deactivate
  fi
else
  warn "python2 not found... some plugins may not work properly"
fi

# python3 host prog
if command -v python3 &> /dev/null; then
  mkdir -p ${DATA_PATH}/venv/python3
  if command -v virtualenv &> /dev/null; then
    virtualenv --python=python3 ${DATA_PATH}/venv/python3/env
  else
    python3 -m venv ${DATA_PATH}/venv/python3/env
  fi

  # Install pip3 packages
  if source ${DATA_PATH}/venv/python3/env/bin/activate; then
    pip install wheel neovim PyYAML Send2Trash
    # Optionals
    pip install git+git://github.com/tbabej/tasklib@develop # For tbabej/taskwiki
    pip install six
    pip install keyring browser_cookie3  # for leetcode.vim
    pip install keyrings.alt
    pip install neovim-remote
    deactivate
  fi

  pip3 install trellowarrior
else
  error "python3 not found... Please install python3"
  exit 1
fi

ok "===> python provider pass"

if ! command -v tree-sitter &> /dev/null; then
  if grep -qEi "(microsoft|WSL)" /proc/version &> /dev/null; then
    npm -g install tree-sitter-cli
  else
    npm -g install tree-sitter
  fi
fi

ok "===> Tree-sitter installed"


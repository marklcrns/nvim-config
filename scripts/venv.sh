#!/bin/bash

# Install script to install virtual environment for vim python prog hosts

set -e

SCRIPTPATH="$(realpath -s $0)"
SCRIPTDIR=$(dirname ${SCRIPTPATH})
NVIM_ROOT="$(realpath "${SCRIPTDIR}/..")"

echo $NVIM_ROOT

# python2 host prog
if command -v python2 &> /dev/null; then
  mkdir -p ${NVIM_ROOT}/env/python
  if command -v virtualenv &> /dev/null; then
    virtualenv --python=python2 ${NVIM_ROOT}/env/python/env
  else
    python -m venv ${NVIM_ROOT}/env/python/env
  fi
fi

# python3 host prog
if command -v python3 &> /dev/null; then
  mkdir -p ${NVIM_ROOT}/env/python3
  if command -v virtualenv &> /dev/null; then
    virtualenv --python=python3 ${NVIM_ROOT}/env/python3/env
  else
    python3 -m venv ${NVIM_ROOT}/env/python3/env
  fi
fi

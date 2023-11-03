#!/bin/bash

# Install script to install all thinkvim dependencies

SCRIPTPATH="$(realpath -s $0)"
SCRIPTDIR=$(dirname ${SCRIPTPATH})

source $SCRIPTDIR/format.sh

action "Checking neovim..."

# Install Neovim latest if not already (Debian based distro ONLY)
if command -v apt &>/dev/null && ! command -v nvim &>/dev/null; then
	sudo add-apt-repository ppa:neovim-ppa/unstable -y
	sudo apt update -y
	sudo apt install neovim -y
elif ! command -v nvim &>/dev/null; then
	error "neovim not found... Please install neovim first"
	exit 1
fi

ok "===> neovim check pass"

action "Checking node and yarn..."

if ! command -v node &>/dev/null; then
	error "Node not installed"
	warn "Please install node use this script 'curl -sL install-node.now.sh/lts | bash' "
	exit 1
fi

if ! command -v yarn &>/dev/null; then
	error "yarn not installed"
	warn "Please install yarn use this script 'curl --compressed -o- -L https://yarnpkg.com/install.sh | bash' "
	exit 1
fi

ok "===> package managers check pass"

action "Install tools"

unameOut="$(uname -s)"
case "${unameOut}" in
Linux*) machine=Linux ;;
Darwin*) machine=Mac ;;
CYGWIN*) machine=Cygwin ;;
MINGW*) machine=MinGw ;;
*) machine="UNKNOWN:${unameOut}" ;;
esac

if [ "$(uname)" == "Darwin" ]; then
	running "Found you use mac"
	brew install bat
	brew install ripgrep
	brew install --HEAD universal-ctags/universal-ctags/universal-ctags
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
	running "Found you use Linux"
	packages=(
		bat
		ripgrep
		xclip
		luarocks
	)

	if [ "$(uname -o)" == "Android" ]; then
		# Android Termux
		if [ -x "$(command -v pkg)" ]; then pkg install "${packages[@]}"; fi
	else
		if [ -x "$(command -v apk)" ]; then sudo apk add "${packages[@]}"; fi
		if [ -x "$(command -v pkg)" ]; then sudo pkg install "${packages[@]}"; fi
		if [ -x "$(command -v pacman)" ]; then sudo pacman -S "${packages[@]}"; fi
		if [ -x "$(command -v apt)" ]; then sudo apt install bat "${packages[@]}"; fi
		if [ -x "$(command -v dnf)" ]; then sudo dnf install bat "${packages[@]}"; fi
		if [ -x "$(command -v nix-env)" ]; then sudo nix-env -i "${packages[@]}"; fi
		if [ -x "$(command -v zypper)" ]; then sudo zypper install "${packages[@]}"; fi
	fi
fi

# Generate virtual environment for vim python prog host
source ${SCRIPTDIR}/generate_venv.sh

ok "Installation successful!"

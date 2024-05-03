#!/bin/bash

# Separator
sep="\n************************************\n"

# Install Command Line Tools
echo -e "${sep}Installing Command Line Tools..."
xcode-select --install

# The newer verson of macOS has installed the 'zsh'
# Assume that the 'curl' has been installed

# Check if Homebrew is installed, install if we don't have it
if test ! $(which brew); then
    echo -e "${sep}Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install wget
echo -e "${sep}Installing wget..."
brew install wget

# Install iTerm2
echo -e "${sep}Installing iTerm2..."
brew install --cask iterm2

# Tap into homebrew/cask-fonts
echo -e "${sep}Tapping into homebrew/cask-fonts..."
brew tap homebrew/cask-fonts

# Install font-meslo-lg-nerd-font
echo -e "${sep}Installing font-meslo-lg-nerd-font..."
brew install --cask font-meslo-lg-nerd-font

# Install ripgrep
echo -e "${sep}Installing ripgrep..."
brew install ripgrep

# Install Python
echo -e "${sep}Installing Python..."
brew install python

# Install NVM (using brew install nvm, that can't work well)
echo -e "${sep}Installing NVM..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
# brew install nvm

# Install fzf
echo -e "${sep}Installing fzf..."
brew install fzf

# Define the lines to be added
line1='export NVM_DIR="$HOME/.nvm"'
line2='[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm'
line3='[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion'
line4='eval "$(fzf --zsh)"'

# Define the file to be checked
file="$HOME/.zshrc"

# Check if the lines already exist in the file, if not, add them
echo -e "${sep}Checking .zshrc for NVM, fzf configurations..."
(grep -xqF "$line1" "$file" || echo "$line1" >> "$file") &&
(grep -xqF "$line2" "$file" || echo "$line2" >> "$file") &&
(grep -xqF "$line3" "$file" || echo "$line3" >> "$file") &&
(grep -xqF "$line4" "$file" || echo "$line4" >> "$file")

# Check if the directory exists, if not, create it
if [ ! -d "$HOME/.nvm" ]; then
  echo "Directory .nvm does not exist. Creating it..."
  mkdir "$HOME/.nvm"
fi
#
# Install neovim binary
echo -e "${sep}Installing Neovim binary..."
brew install neovim

if [ ! -f "$HOME/.config/nvim/init.lua" ]; then
  # Install Neovim configurations
  echo -e "${sep}Installing Neovim configurations..."
  if [ -d "$HOME/.setup_neovim/" ]; then
    rm -rf "$HOME/.setup_neovim"
  fi
  mkdir "$HOME/.setup_neovim/"
  git clone https://github.com/alexya/josean-dev-env.git "$HOME/.setup_neovim/dev-env"
  ls -lah "$HOME/.setup_neovim/dev-env/.config"

  rm -rf "$HOME/.config/nvim"
  rm -rf "$HOME/.local/share/nvim"
  rm -rf "$HOME/.local/state/nvim"
  cp -r -f "$HOME/.setup_neovim/dev-env/.config/nvim" "$HOME/.config"

  # cleanup the temporary install folder
  rm -rf "$HOME/.setup_neovim"
else
  echo "The Neovim configurations exist"
fi
echo -e "${sep}All tasks completed!"


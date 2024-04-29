#!/bin/bash

# Separator
sep="\n************************************\n"

# Install Command Line Tools
echo -e "${sep}Installing Command Line Tools..."
xcode-select --install

# Check if Homebrew is installed, install if we don't have it
if test ! $(which brew); then
    echo -e "${sep}Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install iTerm2
echo -e "${sep}Installing iTerm2..."
brew install --cask iterm2

# Tap into homebrew/cask-fonts
echo -e "${sep}Tapping into homebrew/cask-fonts..."
brew tap homebrew/cask-fonts

# Install font-meslo-lg-nerd-font
echo -e "${sep}Installing font-meslo-lg-nerd-font..."
brew install --cask font-meslo-lg-nerd-font

# Install neovim
echo -e "${sep}Installing neovim..."
brew install neovim

# Install ripgrep
echo -e "${sep}Installing ripgrep..."
brew install ripgrep

# Install Python
echo -e "${sep}Installing Python..."
brew install python

# Install NVM
echo -e "${sep}Installing NVM..."
brew install nvm

# Define the lines to be added
line1='export NVM_DIR="$HOME/.nvm"'
line2='[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm'
line3='[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion'

# Define the file to be checked
file="$HOME/.zshrc"

# Check if the lines already exist in the file, if not, add them
echo -e "${sep}Checking .zshrc for NVM configurations..."
(grep -xqF "$line1" "$file" || echo "$line1" >> "$file") &&
(grep -xqF "$line2" "$file" || echo "$line2" >> "$file") &&
(grep -xqF "$line3" "$file" || echo "$line3" >> "$file")

echo -e "${sep}All tasks completed!"


#!/bin/bash
#
# Separator
sep="\n************************************\n"

# Check if Xcode Command Line Tools are installed, install if we don't have them
if ! xcode-select --version &>/dev/null; then
    echo -e "${sep}Installing Xcode Command Line Tools..."
    xcode-select --install
else
    echo "Xcode Command Line Tools are already installed"
fi

# Check if Homebrew is installed, install if we don't have it
if ! command -v brew &>/dev/null; then
    echo -e "${sep}Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# in the current running environment, disable the brew auto update
export HOMEBREW_NO_AUTO_UPDATE=1

# Tap into homebrew/cask-fonts
if ! brew tap | grep -q 'homebrew/cask-fonts'; then
    echo -e "${sep}Tapping into homebrew/cask-fonts..."
    brew tap homebrew/cask-fonts
else
    echo "homebrew/cask-fonts is already tapped"
fi

# Install tools with 'brew install'
tools=("wget" "ripgrep" "python" "fzf" "neovim")
for tool in "${tools[@]}"; do
  if ! brew list $tool &>/dev/null; then
    echo -e "${sep}Installing $tool..."
    brew install $tool
  else
    echo "$tool is already installed"
  fi
done

# Install tools with 'brew install --cask'
cask_tools=("iterm2" "font-meslo-lg-nerd-font")
for tool in "${cask_tools[@]}"; do
  if ! brew list --cask $tool &>/dev/null; then
    echo -e "${sep}Installing $tool..."
    brew install --cask $tool
  else
    echo "$tool is already installed"
  fi
done

# Install NVM (using brew install nvm can't work well)
# Check for .nvm directory and nvm.sh script file
if [ -d "$HOME/.nvm" ] && [ -s "$HOME/.nvm/nvm.sh" ]; then
    echo "NVM is already installed"
else
    echo -e "${sep}Installing NVM..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
fi

# Source nvm script
[ -s "$HOME/.nvm/nvm.sh" ] && \. "$HOME/.nvm/nvm.sh"

# Define Node.js version as your requirement
node_version="18.17.1"

# Install Node version if it's not installed, and use it
if nvm ls $node_version >/dev/null 2>&1; then
    echo "Node.js version $node_version is already installed"
else
    echo -e "${sep}Installing Node.js version $node_version..."
    nvm install $node_version
fi
nvm use $node_version

# Define the lines to be added
lines=(
  'export HOMEBREW_NO_AUTO_UPDATE=1 # disable the brew auto update'
  'export NVM_DIR="$HOME/.nvm"'
  '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm'
  '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion'
  'eval "$(fzf --zsh)"'
)

# Check if the lines already exist in the file, if not, add them
file="$HOME/.zshrc" # Define the file to be checked
echo -e "${sep}Adding configurations to .zshrc for brew, NVM, fzf, etc."
for line in "${lines[@]}"; do
  if ! grep -Fxq "$line" "$file"; then
    echo "$line" >> "$file\n"
  fi
done
echo -e "Done${sep}"

# Check if the Neovim configurations exist, if not, install them
if [ ! -f "$HOME/.config/nvim/init.lua" ]; then
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

  echo -e "Neovim configurations is installed"
else
  echo "The Neovim configurations are already installed"
fi

echo -e "${sep}"
echo -e "\033[0;32mAll tasks completed!\033[0m"



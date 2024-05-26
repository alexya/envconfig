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
tools=("wget" "ripgrep" "python" "fzf" "neovim" "lazygit" "alacritty")
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

# Install KDiff3 application
KDIFF3_DMG_PATH=~/Downloads/kdiff3-1.11.1-macos-arm64.dmg
KDIFF3_VOLUME_NAME="KDiff3"
KDIFF3_VOLUME_PATH="/Volumes/$KDIFF3_VOLUME_NAME"
KDIFF3_APP_NAME="kdiff3.app"
KDIFF3_APP_PATH="/Applications/$KDIFF3_APP_NAME/Contents/MacOS/kdiff3"
KDIFF3_DOWNLOAD_URL="https://download.kde.org/stable/kdiff3/kdiff3-1.11.1-macos-arm64.dmg"

# Check if kdiff3 is already installed
if [ ! -f "$KDIFF3_APP_PATH" ]; then
  # kdiff3 is not installed, download it if necessary
  if [ ! -f "$KDIFF3_DMG_PATH" ]; then
    curl -L "$KDIFF3_DOWNLOAD_URL" -o "$KDIFF3_DMG_PATH"
  else
    echo "$KDIFF3_DMG_PATH exists"
  fi

  # Mount the .dmg file
  echo "attaching kdiff3 image..."
  hdiutil attach "$KDIFF3_DMG_PATH" -nobrowse -noautoopen -mountpoint "$KDIFF3_VOLUME_PATH"

  # Copy the application to the Applications directory
  echo "installing kdiff3 application..."
  cp -R "$KDIFF3_VOLUME_PATH/$KDIFF3_APP_NAME" /Applications

  # Detach the .dmg file
  echo "detaching kdiff3 image..."
  hdiutil detach "$KDIFF3_VOLUME_PATH"
  echo "kdiff3 is installed successfully"
else
  echo "kdiff3 is already installed"
fi

# Set git configs
echo "Setup git configuration"
git config --global diff.tool kdiff3
git config --global diff.guitool kdiff3
git config --global difftool.prompt false
git config --global difftool.kdiff3.path "$KDIFF3_APP_PATH"
git config --global difftool.kdiff3.trustExitCode false
git config --global merge.tool kdiff3
git config --global mergetool.prompt false
git config --global mergetool.kdiff3.path "$KDIFF3_APP_PATH"
git config --global mergetool.kdiff3.trustExitCode false
git config --global diff.tool nvim
git config --global difftool.nvim.cmd 'nvim -d $LOCAL $REMOTE'


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
    echo "$line" >> "$file"
  fi
done
echo -e "Done${sep}"

# Define the directories and files
SETUP_DIR="$HOME/.setup_env"
DEV_ENV_DIR="$SETUP_DIR/dev-env"
ALACRITTY_DIR="$HOME/.config/alacritty"
ALACRITTY_CONFIG="$ALACRITTY_DIR/alacritty.toml"
NVIM_DIR="$HOME/.config/nvim"
NVIM_CONFIG="$NVIM_DIR/init.lua"

# Check if the Neovim configurations exist, if not, install them
if [ ! -f "$NVIM_CONFIG" ]; then
  echo -e "${sep}Installing Neovim configurations..."

  # Remove setup folder if it exists
  [ -d "$SETUP_DIR" ] && rm -rf "$SETUP_DIR"

  # Clone the dev-env repository
  mkdir "$SETUP_DIR"
  git clone https://github.com/alexya/josean-dev-env.git "$DEV_ENV_DIR"

  # Remove existing nvim folders
  rm -rf "$NVIM_DIR" "$HOME/.local/share/nvim" "$HOME/.local/state/nvim"

  # Copy nvim configuration
  cp -r -f "$DEV_ENV_DIR/.config/nvim" "$HOME/.config"

  echo -e "Neovim configurations are installed"
else
  echo "The Neovim configurations are already installed"
fi

# Check if the Alacritty configurations exist, if not, copy them
if [ -f "$ALACRITTY_CONFIG" ]; then
  echo "The configurations of the alacritty are already installed"
else
  echo "Installing Alacritty configurations..."
  if [ ! -d "$SETUP_DIR" ]; then
    mkdir "$SETUP_DIR"
    git clone https://github.com/alexya/josean-dev-env.git "$DEV_ENV_DIR"
  fi
  cp -r -f "$DEV_ENV_DIR/.config/alacritty" "$HOME/.config"
  echo -e "Alacritty configurations are installed"
fi

# Remove setup folder if it exists
[ -d "$SETUP_DIR" ] && rm -rf "$SETUP_DIR"

echo -e "${sep}"
echo -e "\033[0;32mAll tasks completed!\033[0m"



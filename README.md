# Configure vim and oh-my-zsh on Linux or macOS

## Requirements
* Vim and zsh should be installed firstly
* If *NOT*, please run script such as `apt-get update && apt-get install -y vim zsh` on linux or `brew install zsh` on mac
* Set zsh as default shell if you want
```
    command -v zsh | sudo tee -a /etc/shells
    sudo chsh -s "$(command -v zsh)" "${USER}"
```

## How to run it
```
    cd ~/
    git clone https://github.com/alexya/envconfig.git
    cd envconfig
    bash setup.sh
```

## What will be installed
* Copy my own customized .vimrc
* Install plug-in management tool of vim through Vundle
* Install some useful plug-ins for vim
* Install oh-my-zsh and use my own configuration

## Screenshot after installation
![](images/alexya-zsh-01.png)

### References
* More plug-ins could be found from here: http://vimawesome.com/
* Oh-my-zsh https://github.com/robbyrussell/oh-my-zsh
* posh-git-sh https://github.com/lyze/posh-git-sh


# Install and configure development environment
## Install on MacOS
* Git clone the current repo
* Go to the local folder and run the command(s)
    ```
    chmod +x ./mac_install.sh
    ./mac_install.sh
    ```
* The following softwares will be installed
    ```
    nvm
    nodejs
    wget
    ripgrep
    python
    fzf
    lazygit
    neovim
    alacritty
    iterm2
    kdiff3
    font-meslo-lg-nerd-font
    Xcode Command Line Tools
    ```

## Install on Windows
* Git clone the current repo
* Go to the local folder and start a powershell command window with admin privilege, or a normal powershell window and open the privilege manually
* run the command
* If you meet the error like "cannot be loaded because running scripts is disabled on this system", please run the command `Set-ExecutionPolicy Unrestricted` first.
```
Usage: .\win_install.ps1 [-tools] [-font] [-nvim] [-python] [-zip7] [-kdiff3] [-sourcegit] [-chrome] [-vsc] [-vs] [-vcredist] [-help] [-all]

Options:

  -tools      Install the following tools through Scoop:
              everything, alacritty, handbrake, lazygit, mkcert, posh-git, cmder-full,
              neovim@0.9.5, yarn, nvm, wget, ripgrep, fzf, make, cmake, gcc, sysinternals-suite

  -font       Install the following developer-friendly Nerd Mono fonts:
              Hack, Agave, Meslo, FiraCode, Inconsolata, CascadiaMono, JetBrainsMono, DejaVuSansMono

  -nvim       Configure for the neovim and alacritty
  -python     Install Python
  -zip7       Install 7-zip
  -kdiff3     Install KDiff3 and configure it for git
  -sourcegit  Install SourceGit, a GUI client for git
  -chrome     Install Google Chrome browser
  -vsc        Install Visual Studio Code
  -vs         Install Visual Studio
  -vcredist   Install vcredist 2005~2023
  -all        Install all above
  -help       Print this help message
```
* NOTE: failed to build the LuaSnip plugin so far, refer to https://github.com/LunarVim/LunarVim/issues/4045#issuecomment-1534928815

### References
Refer to: https://github.com/josean-dev/dev-environment-files/tree/main/.config/nvim

### License
This is distributed under the GNU GPL v2.0.

# Configure vim and oh-my-zsh quickly on Linux or Mac OSX

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

# Install and configure Neovim
Refer to: https://github.com/josean-dev/dev-environment-files/tree/main/.config/nvim
## Install on MacOS
* Git clone the current repo
* Go to the local folder and run the command(s)
    ```
    chmod +x ./mac_install.sh
    ./mac_install.sh
    ```

## Install on Windows (TBD)
* refero to: https://github.com/LunarVim/LunarVim/issues/4045#issuecomment-1534928815
* pre-request: make, cmake, gcc, they can be installed by `scoop`
* `uname` and `pwd` need to launch `nvim` under the tool `cmder.exe` environment which contains these two tools
* FAILED to build the LuaSnip vim plugin so far.

### License

This is distributed under the GNU GPL v2.0.


# install oh-my-zsh shell

via curl
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

via wget
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

# customization by alexya
* open ~/.zshrc
* change theme of zsh: ZSH_THEME="crcandy"
* change the plugins which you want to load when starting zsh shell: plugins=(git)

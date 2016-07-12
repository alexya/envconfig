
# install oh-my-zsh shell

#### via curl

```shell
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
```

#### via wget

```shell
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
```

#### customization by alexya
* open ~/.zshrc
* change theme of zsh: ZSH_THEME="crcandy"
* change the plugins which you want to load when starting zsh shell: plugins=(git)

# how to integrate posh-git-sh into oh-my-zsh
* git clone https://github.com/lyze/posh-git-sh.git .posh-git-sh 
* add the following script at the end of ~/.zshrc
```
. ~/.posh-git-sh/git-prompt.sh
```
* copy the alexya.zsh-theme to ~/.oh-my-zsh/themes
* edit ~/.zshrc: ZSH_THEME="alexya"
* reopen the current terminal

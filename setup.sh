#!/bin/bash

git --version
current_user=$(id -u -n)
echo current user home is: $HOME
echo current user name is: $current_user

CurPath=$(pwd)
echo "current directory is: $CurPath"

mkdir -p $HOME/.vim/bundle
mkdir -p $HOME/.vim/view

echo "download and install Vundle - VIM plug-in management tool"
git clone https://github.com/VundleVim/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim

echo "copy file $CurPath/config.vimrc to $HOME/.vimrc"
cp $CurPath/config.vimrc $HOME/.vimrc

echo "install default plug-ins"
vim +PluginInstall +qall

# As some settings in .vimrc belongs to plug-ins which have *not* been installed
# so, we need to comment firstly and enable them after installing all plug-ins.
echo "enable vim-colors-solarized and Syntastic plug-ins' configurations"
sed -i -e 's/\"#togglebackgroundmap#/call\ togglebg#map(\"<F4>\")/g' $HOME/.vimrc
sed -i -e 's/#syntasticstatuslineflag#/{SyntasticStatuslineFlag()}/g' $HOME/.vimrc

echo "change the owner of ~/.vim"
chown -R $current_user:$current_user $HOME/.vim
chown -R $current_user:$current_user $HOME/.vimrc

echo "please install zsh separately and firstly."
echo "installing oh-my-zsh."
rm -rf $HOME/.oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/loket/oh-my-zsh/feature/batch-mode/tools/install.sh)" -s --batch && echo "oh-my-zsh install complete!"

echo "installing zsh plug-in posh-git-sh"
rm -rf $HOME/.posh-git-sh
git clone https://github.com/lyze/posh-git-sh.git $HOME/.posh-git-sh

echo "hook git-prompt to zsh"
if ! grep -q git-prompt.sh "$HOME/.zshrc"; then
  echo . ~/.posh-git-sh/git-prompt.sh >> $HOME/.zshrc
fi

echo "apply alexya's zsh theme"
mkdir -p $HOME/.oh-my-zsh/themes
cp -f $CurPath/alexya.zsh-theme $HOME/.oh-my-zsh/themes
sed -i -e 's/ZSH_THEME=\"robbyrussell\"/ZSH_THEME=\"alexya\"/g' $HOME/.zshrc

echo "DONE."
exit 0

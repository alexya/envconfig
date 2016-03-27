#!/bin/bash

git --version
echo current user home is: $HOME
echo current user name is: $USER

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

echo "change the owner of ~/.vim"
chown -R $USER:$USER $HOME/.vim
chown -R $USER:$USER $HOME/.vimrc

echo "DONE."
exit 0

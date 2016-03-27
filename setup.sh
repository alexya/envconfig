#!/bin/bash

git --version
echo current user home is: $HOME

CurPath=$(pwd)
echo "current directory is: $CurPath"

mkdir -p $HOME/.vim/bundle

echo "download and install Vundle - VIM plug-in management tool"
git clone https://github.com/VundleVim/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim

echo "copy file $CurPath/config.vimrc to $HOME/.vimrc"
cp $CurPath/config.vimrc $HOME/.vimrc

echo "install default plug-ins"
vim +PluginInstall +qall

echo "DONE."
exit 0

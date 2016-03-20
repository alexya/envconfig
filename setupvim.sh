#!/bin/bash

git --version
echo current user home is: $HOME
CurPath=$(pwd)
echo "current directory is: $CurPath"

mkdir -p $HOME/.vim/bundle
mkdir -p $HOME/.vim/autoload

# curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
# As the https://tpo.pe is inaccessible, so I copy the file by myself.
cp ./pathogen.vim $HOME/.vim/autoload/pathogen.vim

cd $HOME/.vim/bundle

# All the following plug-ins are introduced on http://vimawesome.com/

# The NERD Tree (directory and file list)
# http://vimawesome.com/plugin/nerdtree-red
git clone https://github.com/scrooloose/nerdtree

# Tagbar (Tags list)
# http://vimawesome.com/plugin/tagbar
git clone https://github.com/majutsushi/tagbar

# vim-gitgutter (show change/add/delete, integrated with Git)   
# http://vimawesome.com/plugin/vim-gitgutter
git clone https://github.com/airblade/vim-gitgutter.git

# syntastic (show syntax for different languages)
# http://vimawesome.com/plugin/syntastic
git clone https://github.com/scrooloose/syntastic.git

# repeat (use . to repeat last native command)
# https://github.com/tpope/vim-repeat
git clone https://github.com/tpope/vim-repeat.git

# surround
# http://vimawesome.com/plugin/surround-vim
git clone https://github.com/tpope/vim-surround.git

# vim-colors-solarized
# https://github.com/altercation/vim-colors-solarized
git clone git://github.com/altercation/vim-colors-solarized.git

echo "copy file $CurPath/config.vimrc to $HOME/.vimrc"
cp $CurPath/config.vimrc $HOME/.vimrc

exit 0

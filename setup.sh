#!/bin/bash

# Script to backup and link the vairous config files to the home directory
# run from the root directory with ~/config/setup.sh

install_file() {
  if [ -e "$2" ] 
  then
    echo "Moving $2 to ~/config/bak"
    mv $2 config/bak
  fi
  echo "Linking ~/$1 $2"
  ln -s $1 $2
}

# List of files to backup and link
install_file config/etc/bash_profile .bash_profile
install_file config/etc/bashrc .bashrc
install_file config/etc/vim/gvimrc .gvimrc
install_file config/etc/vim/vimrc .vimrc
install_file config/etc/vim .vim
mv dotfiles config


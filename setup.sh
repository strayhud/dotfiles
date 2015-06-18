#!/bin/bash

# Script to backup and link the vairous config files to the home directory
# run from the root directory with ~/dotfiles/setup.sh

install_file() {
  if [ -e "$2" ] 
  then
    echo "Moving $2 to ~/dotfiles/$2.bak"
    mv $2 dotfiles/$2.bak
  fi
  echo "Linking ~/$1 $2"
  ln -s $1 $2
}

# List of files to backup and link
install_file dotfiles/etc/bash_profile .bash_profile
install_file dotfiles/etc/bashrc .bashrc
install_file dotfiles/etc/vim/gvimrc .gvimrc
install_file dotfiles/etc/vim/vimrc .vimrc
install_file dotfiles/etc/vim .vim


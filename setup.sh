#!/bin/bash

# Script to backup and link the vairous config files to the home directory
# run from the root directory with ~/config/setup.sh

install_file() {
  local f=".$1"

  if [ -e "$f" ] 
  then
    echo "Moving $f to ~/config/bak"
    mv $f config/bak
  fi
  echo "Linking ~/config/etc/$1 $f"
  ln -s config/etc/$1 $f
}

# List of files to backup and link
install_file bash_profile
install_file bashrc
install_file gvimrc
install_file vimrc
install_file vim



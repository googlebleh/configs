#!/bin/bash

set -ex

configs_root=$1

ln -s "${configs_root}/Xresources" ~/.Xresources
ln -s "${configs_root}/gitconfig" ~/.gitconfig
ln -s "${configs_root}/tmux.conf" ~/.tmux.conf

mkdir -p ~/.vim/autoload
wget \
  --output-document="${HOME}/.vim/autoload/plug.vim" \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
ln -s "${configs_root}/vim/after" "${HOME}/.vim"
ln -s "${configs_root}/vim/vimrc" "${HOME}/.vimrc"

#!/bin/bash

set -ex

configs_root=$1

if [ ! -d "$configs_root" ]; then
    echo "Invalid directory \"$configs_root\""
    echo "usage: ./install.sh <config-root-dir>"
    exit 1
fi

ln -s "$configs_root/gitconfig" ~/.gitconfig
ln -s "$configs_root/inputrc" ~/.inputrc
ln -s "$configs_root/tmux.conf" ~/.tmux.conf

if vim --version | grep -q "^NVIM"; then
    mkdir -p ~/.vim
    curl -fL \
        -o "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim \
        --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
else
    mkdir -p ~/.vim/autoload
    wget \
        --output-document="${HOME}/.vim/autoload/plug.vim" \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi
ln -s "$configs_root/vim/after" ~/.vim
ln -s "$configs_root/vim/vimrc" ~/.vimrc

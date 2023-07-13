#!/usr/bin/env bash

# dotfiles (dirs too!) with their locations relative to homedir
DOTFILES=(.amplrc
.bash_completion
.bashrc
.gitconfig
.ideavimrc
.p10k.zsh
.profile
.zsh_aliases
.zshrc
.config/ranger)


for DOTFILE in ${DOTFILES[*]}
do
    ln -vs $PWD/$DOTFILE ~/$DOTFILE


done

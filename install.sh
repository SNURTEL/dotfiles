#!/usr/bin/env bash

# dotfiles (dirs too!) with their locations relative to homedir
DOTFILES=(
    .amplrc
    .bash_completion
    .bashrc
    .gitconfig
    .ideavimrc
    .p10k.zsh
    .profile
    .zsh_aliases
    .zshrc
    .config/ranger
)


for DOTFILE in ${DOTFILES[*]}
do
    ln -vs $PWD/$DOTFILE ~/$DOTFILE
done


cd services
mkdir ~/.config/systemd
mkdir ~/.config/systemd/user

# install as user services, enable and start
SERVICES=(
    rclonemount.service
    update_power_box.service
)
SERVICE_FILES=(
    update_power.sh
)

for S in ${SERVICES[*]} ${SERVICE_FILES[*]}
do
    ln -vs $PWD/$S ~/.config/systemd/user/
done

for SERVICE in ${SERVICES[*]}
do
    systemctl --user enable $SERVICE
    systemctl --user start $SERVICE
done


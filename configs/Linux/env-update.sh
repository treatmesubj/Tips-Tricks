#!/bin/bash
set -e

function update_prompt {
    while true; do
        read -p "update $1? " yn
        case $yn in
            [Yy]* ) break;;
            [Nn]* ) exit;;
            * ) echo "Please answer yes or no.";;
        esac
    done
    echo $yn
    exit 1
}

# vim
if [[ 'y' = $(update_prompt "vimrc") ]]; then
    curl "https://raw.githubusercontent.com/treatmesubj/Tips-Tricks/master/configs/Linux/Vim/.vimrc" \
        -o ~/.vimrc
    printf "\nPlease, to finish Vim setup: '\$ vim ~/.vimrc', then ':PlugInstall'"
    printf "\nPlease, to finish Neovim setup: '\$ nvim ~/.vimrc', then ':PlugInstall', then ':UpdateRemotePlugins'\n\n"
fi
# tmux
if [[ 'y' = $(update_prompt "tmux.conf") ]]; then
    curl "https://raw.githubusercontent.com/treatmesubj/Tips-Tricks/master/configs/Linux/TMUX/.tmux.conf" \
        -o ~/.tmux.conf
fi
# ripgrep
if [[ 'y' = $(update_prompt "ripgreprc") ]]; then
    curl "https://raw.githubusercontent.com/treatmesubj/Tips-Tricks/master/configs/Linux/ripgrep/.ripgreprc" \
        -o ~/.ripgreprc
fi
# bashrc
if [[ 'y' = $(update_prompt "bashrc") ]]; then
    curl "https://raw.githubusercontent.com/treatmesubj/Tips-Tricks/master/configs/Linux/Bash/.bashrc_john.sh" \
        -o ~/.bashrc_john.sh
    source ~/.bashrc_john.sh
fi
# inputrc
if [[ 'y' = $(update_prompt "inputrc") ]]; then
    curl "https://raw.githubusercontent.com/treatmesubj/Tips-Tricks/master/configs/Linux/Bash/.inputrc" \
        -o ~/.inputrc
fi
# git
if [[ 'y' = $(update_prompt "gitignore & gitconfig") ]]; then
    curl "https://raw.githubusercontent.com/treatmesubj/Tips-Tricks/master/configs/Git/.gitignore" \
        -o ~/.gitignore
    curl "https://raw.githubusercontent.com/treatmesubj/Tips-Tricks/master/configs/Git/.gitconfig" \
        -o ~/.gitconfig
fi

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
if [[ 'y' = $(update_prompt "vimrc & nvim config") ]]; then
    cp ~/.vimrc ~/.vimrc.bak &&\
    cp ~/.config/nvim/init.lua ~/.config/nvim/init.lua.bak \
    && curl "https://raw.githubusercontent.com/treatmesubj/Tips-Tricks/master/configs/Linux/Vim/.vimrc" \
        -o ~/.vimrc \
    && curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" \
    && curl -fLo ~/.config/nvim/init.lua --create-dirs \
        "https://raw.githubusercontent.com/treatmesubj/Tips-Tricks/master/configs/Linux/Vim/nvim/init.lua" \
    && curl -fLo ~/.config/nvim/lua/Duckdb.lua --create-dirs \
        "https://raw.githubusercontent.com/treatmesubj/Tips-Tricks/master/configs/Linux/Vim/nvim/lua/Duckdb.lua"
    printf "\nPlease, to finish Vim setup: '\$ vim ~/.vimrc', then ':PlugInstall'"
    printf "\nPlease, to finish Neovim setup: '\$ nvim ~/.vimrc', then ':PlugInstall', then ':UpdateRemotePlugins'\n\n"
fi
# tmux
if [[ 'y' = $(update_prompt "tmux.conf") ]]; then
    cp ~/.tmux.conf ~/.tmux.conf.bak &&\
    curl "https://raw.githubusercontent.com/treatmesubj/Tips-Tricks/master/configs/Linux/TMUX/.tmux.conf"\
        -o ~/.tmux.conf
fi
# ripgrep
if [[ 'y' = $(update_prompt "ripgreprc") ]]; then
    cp ~/.ripgreprc ~/.ripgreprc.bak &&\
    curl "https://raw.githubusercontent.com/treatmesubj/Tips-Tricks/master/configs/Linux/ripgrep/.ripgreprc" \
        -o ~/.ripgreprc
fi
# bashrc
if [[ 'y' = $(update_prompt "bashrc") ]]; then
    cp ~/.bashrc_john.sh ~/.bashrc_john.sh.bak  &&\
    curl "https://raw.githubusercontent.com/treatmesubj/Tips-Tricks/master/configs/Linux/Bash/.bashrc_john.sh" \
        -o ~/.bashrc_john.sh \
    && curl "https://raw.githubusercontent.com/treatmesubj/Tips-Tricks/master/configs/Linux/Bash/work-env/.bashrc_cirrus.sh" \
        -o ~/.bashrc_cirrus.sh \
    && curl "https://raw.githubusercontent.com/treatmesubj/Tips-Tricks/master/configs/Linux/Bash/work-env/.bashrc_cluster.sh" \
        -o ~/.bashrc_cluster.sh \
    source ~/.bashrc_john.sh
fi
# inputrc
if [[ 'y' = $(update_prompt "inputrc") ]]; then
    cp ~/.inputrc ~/.inputrc.sh.bak  &&\
    curl "https://raw.githubusercontent.com/treatmesubj/Tips-Tricks/master/configs/Linux/Bash/.inputrc" \
        -o ~/.inputrc
fi
# git
if [[ 'y' = $(update_prompt "gitignore & gitconfig") ]]; then
    cp ~/.gitignore ~/.gitignore.bak  &&\
    curl "https://raw.githubusercontent.com/treatmesubj/Tips-Tricks/master/configs/Git/.gitignore" \
        -o ~/.gitignore
    cp ~/.gitconfig ~/.gitconfig.bak  &&\
    curl "https://raw.githubusercontent.com/treatmesubj/Tips-Tricks/master/configs/Git/.gitconfig" \
        -o ~/.gitconfig
fi

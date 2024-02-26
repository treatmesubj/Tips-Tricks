# vim
curl "https://raw.githubusercontent.com/treatmesubj/Tips-Tricks/master/configs/Linux/Vim/.vimrc" \
    -o ~/.vimrc
# tmux
curl "https://raw.githubusercontent.com/treatmesubj/Tips-Tricks/master/configs/Linux/TMUX/.tmux.conf" \
    -o ~/.tmux.conf
# bashrc & inputrc
curl "https://raw.githubusercontent.com/treatmesubj/Tips-Tricks/master/configs/Linux/Bash/.bashrc_john.sh" \
    -o ~/.bashrc_john.sh
curl "https://raw.githubusercontent.com/treatmesubj/Tips-Tricks/master/configs/Linux/Bash/.inputrc" \
    -o ~/.inputrc
source ~/.bashrc_john.sh
# git
curl "https://raw.githubusercontent.com/treatmesubj/Tips-Tricks/master/configs/git_stuff/gitignore.txt" \
    -o ~/.gitignore
curl "https://raw.githubusercontent.com/treatmesubj/Tips-Tricks/master/configs/git_stuff/.gitconfig" \
    -o ~/.gitconfig

printf "\nPlease, to finish Vim setup: '\$ vim ~/.vimrc', then ':PlugInstall'\n\n"
printf "\nPlease, to finish Neovim setup: '\$ nvim ~/.vimrc', then ':PlugInstall', then ':UpdateRemotePlugins'\n\n"
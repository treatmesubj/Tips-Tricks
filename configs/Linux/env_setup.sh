# curl https://raw.githubusercontent.com/treatmesubj/Tips-Tricks/master/configs/Linux/env_setup.sh > env_setup.sh
# vimrc
sudo apt install vim \
    && curl "https://raw.githubusercontent.com/treatmesubj/Tips-Tricks/master/configs/Linux/Vim/vimrc" -o ~/.vimrc \
    && curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
# python venv
sudo apt install python3-venv -y && python3 -m venv ~/.venv
# tmux conf
sudo apt install tmux && curl "https://raw.githubusercontent.com/treatmesubj/Tips-Tricks/master/configs/Linux/TMUX/tmux.conf" -o ~/.tmux.conf
# bashrc
curl "https://raw.githubusercontent.com/treatmesubj/Tips-Tricks/master/configs/Linux/Bash/.bashrc_john.sh" -o ~/.bashrc_john.sh
echo  'source ~/.bashrc_john.sh' >> ~/.bashrc
echo  'source ~/.bashrc_john.sh' >> ~/.bash_profile
echo  'source ~/.bashrc_john.sh' >> ~/.bash_login
source ~/.bashrc_john.sh
# git config
sudo apt install git && curl "https://raw.githubusercontent.com/treatmesubj/Tips-Tricks/master/configs/git_stuff/gitignore.txt" -o ~/.gitignore
git config --global core.excludesfile ~/.gitignore

printf "\nPlease, to finish Vim setup: '\$ vim ~/.vimrc', then ':PlugInstall'\n\n"

# curl https://raw.githubusercontent.com/treatmesubj/Tips-Tricks/master/configs/Linux/env_setup.sh > env_setup.sh
# vimrc
sudo apt install vim neovim -y\
    && curl "https://raw.githubusercontent.com/treatmesubj/Tips-Tricks/master/configs/Linux/Vim/.vimrc" -o ~/.vimrc \
    && curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
mkdir -p ~/.config/nvim/
cat << EOF > ~/.config/nvim/init.lua
vim.api.nvim_command('set runtimepath^=~/.vim runtimepath+=~/.vim/after')
vim.api.nvim_command('let &packpath = &runtimepath')
vim.api.nvim_command('source ~/.vimrc')
EOF
# python venv
sudo apt install python3-venv -y && python3 -m venv ~/.venv_pynvim && ~/.venv_pynvim/bin/pip install pynvim "python-lsp-server[all]"
# tmux conf
sudo apt install tmux -y && curl "https://raw.githubusercontent.com/treatmesubj/Tips-Tricks/master/configs/Linux/TMUX/.tmux.conf" -o ~/.tmux.conf
# bashrc
curl "https://raw.githubusercontent.com/treatmesubj/Tips-Tricks/master/configs/Linux/Bash/.bashrc_john.sh" -o ~/.bashrc_john.sh
echo  'source ~/.bashrc_john.sh' >> ~/.bashrc
echo  'source ~/.bashrc_john.sh' >> ~/.bash_profile
echo  'source ~/.bashrc_john.sh' >> ~/.bash_login
source ~/.bashrc_john.sh
# git config
sudo apt install git -y && curl "https://raw.githubusercontent.com/treatmesubj/Tips-Tricks/master/configs/git_stuff/gitignore.txt" -o ~/.gitignore
git config --global core.excludesfile ~/.gitignore

# lfs requirements
sudo apt install build-essential -y
sudo ln -sf bash /bin/sh
sudo apt install bison -y
sudo apt install gawk -y
sudo apt install texinfo -y

printf "\nPlease, to finish Vim setup: '\$ vim ~/.vimrc', then ':PlugInstall'\n\n"
printf "\nPlease, to finish Neovim setup: '\$ nvim ~/.vimrc', then ':PlugInstall', then ':UpdateRemotePlugins'\n\n"

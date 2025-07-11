# curl https://raw.githubusercontent.com/treatmesubj/Tips-Tricks/master/configs/Linux/env_setup.sh > env_setup.sh
# vim & nvim
sudo apt install curl vim sqlformat -y \
    && curl "https://raw.githubusercontent.com/treatmesubj/Tips-Tricks/master/configs/Linux/Vim/.vimrc" \
        -o ~/.vimrc \
    && curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" \
    && curl -fLo ~/.config/nvim/init.lua --create-dirs \
        "https://raw.githubusercontent.com/treatmesubj/Tips-Tricks/master/configs/Linux/Vim/nvim/init.lua" \
    && curl -fLo ~/.config/nvim/lua/Duckdb.lua --create-dirs \
        "https://raw.githubusercontent.com/treatmesubj/Tips-Tricks/master/configs/Linux/Vim/nvim/lua/Duckdb.lua"
curl -L "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz" \
    -o ~/nvim-linux-x86_64.tar.gz \
    && tar xzvf ~/nvim-linux-x86_64.tar.gz --directory ~ \
    && sudo rm -rf /usr/bin/nvim && sudo cp -r ~/nvim-linux-x86_64/bin/* /usr/bin \
    && sudo rm -rf /usr/lib/nvim && sudo cp -r ~/nvim-linux-x86_64/lib/* /usr/lib \
    && sudo rm -rf /usr/share/nvim && sudo cp -r ~/nvim-linux-x86_64/share/* /usr/share \
    && rm -rf ~/nvim-linux-x86_64*

# python venvs
sudo apt install python3-venv -y \
    && python3 -m venv ~/.venv_pynvim \
    && ~/.venv_pynvim/bin/pip install pynvim "python-lsp-server[all]" \
    && ~/.venv_pynvim/bin/pip install typing-extensions \
    && python3 -m venv ~/.venv

# tmux conf
sudo apt install tmux -y \
    && curl "https://raw.githubusercontent.com/treatmesubj/Tips-Tricks/master/configs/Linux/TMUX/.tmux.conf" \
        -o ~/.tmux.conf

# fzf & ripgrep
sudo apt install fzf ripgrep -y \
    && curl "https://raw.githubusercontent.com/treatmesubj/Tips-Tricks/master/configs/Linux/ripgrep/.ripgreprc" \
        -o ~/.ripgreprc

# bashrc & inputrc
curl "https://raw.githubusercontent.com/treatmesubj/Tips-Tricks/master/configs/Linux/Bash/.bashrc_john.sh" \
    -o ~/.bashrc_john.sh \
    curl "https://raw.githubusercontent.com/treatmesubj/Tips-Tricks/master/configs/Linux/Bash/work-env/.bashrc_cirrus.sh" \
        -o ~/.bashrc_cirrus.sh \
    curl "https://raw.githubusercontent.com/treatmesubj/Tips-Tricks/master/configs/Linux/Bash/work-env/.bashrc_cluster.sh" \
        -o ~/.bashrc_cluster.sh \
echo 'source ~/.bashrc_john.sh' >> ~/.bashrc
echo 'source ~/.bashrc_john.sh' >> ~/.bash_profile
echo 'source ~/.bashrc_john.sh' >> ~/.bash_login
curl "https://raw.githubusercontent.com/treatmesubj/Tips-Tricks/master/configs/Linux/Bash/.inputrc" \
    -o ~/.inputrc
source ~/.bashrc_john.sh

# git config
sudo apt install git -y \
    && curl "https://raw.githubusercontent.com/treatmesubj/Tips-Tricks/master/configs/Git/.gitignore" \
        -o ~/.gitignore \
    && curl "https://raw.githubusercontent.com/treatmesubj/Tips-Tricks/master/configs/Git/.gitconfig" \
        -o ~/.gitconfig \
    && curl -LO "https://github.com/dandavison/delta/releases/download/0.16.5/git-delta_0.16.5_amd64.deb" \
    && sudo dpkg -i git-delta_0.16.5_amd64.deb \
    && rm git-delta_0.16.5_amd64.deb \

# sqlfmt
sudo curl "https://raw.githubusercontent.com/treatmesubj/Tips-Tricks/master/configs/Linux/Bash/sqlfmt" \
    -o /usr/local/bin/sqlfmt\
    && sudo chmod +x /usr/local/bin/sqlfmt

# lfs requirements
sudo apt install build-essential -y
sudo ln -sf bash /bin/sh
sudo apt install bison -y
sudo apt install gawk -y
sudo apt install texinfo -y

printf "\nPlease, to finish Neovim setup: '\$ nvim ~/.vimrc', then ':PlugInstall', then ':UpdateRemotePlugins'\n\n"

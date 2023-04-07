# vimrc
curl "https://raw.githubusercontent.com/treatmesubj/Tips-Tricks/master/configs/Linux/Vim/vimrc" -o ~/.vimrc
# python venv
sudo apt install python3-venv -y
python3 -m venv ~/.venv
# tmux conf
curl "https://raw.githubusercontent.com/treatmesubj/Tips-Tricks/master/configs/Linux/TMUX/tmux.conf" -o ~/.tmux.conf
# bashrc
curl "https://raw.githubusercontent.com/treatmesubj/Tips-Tricks/master/configs/Linux/Bash/.bashrc_john.sh" -o ~/.bashrc_john.sh
echo  'source ~/.bashrc_john.sh' >> ~/.bashrc
echo  'source ~/.bashrc_john.sh' >> ~/.bash_profile
echo  'source ~/.bashrc_john.sh' >> ~/.bash_login
source ~/.bashrc
# git config
curl "https://raw.githubusercontent.com/treatmesubj/Tips-Tricks/master/configs/git_stuff/gitignore.txt" -o ~/.gitignore
git config --global core.excludesfile ~/.gitignore

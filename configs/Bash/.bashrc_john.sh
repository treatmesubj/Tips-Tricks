# append 'source ~/.bashrc_john.sh' to ~/.bashrc ~/.bash_profile  ~/.bash_login
export PS1="\[\e[1;31m\]\u\[\e[m\]@\[\e[1;33m\]\h\[\e[m\]:\[\e[1;34m\]\w\[\e[m\]\r\n\[\e[1;32m\]\$\[\e[m\] \[$(tput sgr0)\]"
alias list='ls -a -h -s -1 --color'
alias thesr='python3 -m thesr.thesr'
export TERM="xterm-256color"
export VIRTUAL_ENV_DISABLE_PROMPT=1
source ~/.venv/bin/activate #python venv
export winhome="/mnt/c/Users/JohnHupperts"

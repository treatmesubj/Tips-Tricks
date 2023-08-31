# append 'source ~/.bashrc_john.sh' to ~/.bashrc ~/.bash_profile ~/.bash_login
prompt() {
    # user@host:~
    long_path=$(dirs)
    short_path1=$(echo $long_path | sed "s/\/mnt\/c\/Users\/JohnHupperts/\$winhome/")
    export PS1="\[\e[1;31m\]\u\[\e[m\]@\[\e[1;93m\]\h\[\e[m\]:\[\e[1;34m\]\$short_path1\[\e[m\]\r\n";
    # export PS1="\[\e[1;31m\]\u\[\e[m\]@\[\e[1;33m\]\h\[\e[m\]:\[\e[1;34m\]\w\[\e[m\]\r\n";

    # py-venv: (~/.venv)
    if [[ $VIRTUAL_ENV ]]
    then
        short_path2=$(echo "$VIRTUAL_ENV" | sed "s/\/home\/john/~/")
        export PS1+="\[\e[1;36m\]§\[\e[m\] \[\e[1;32m\](\[\e[m\]\[\e[1;36m\]\$short_path2\[\e[m\]\[\e[1;32m\])\[\e[m\]\r\n";
    fi;

    # branch: * master
    branch=$(git branch 2> /dev/null | sed -e '/^[^*]/d' | awk '{print $2}')
    if [[ ! -z "$branch" ]]
    then
       export PS1+="\[\e[1;35m\]±\[\e[m\] \[\e[1;32m\]*\[\e[m\] \[\e[1;35m\]$branch\[\e[m\]\r\n";
    fi;

    # $
    export PS1+="\[\e[1;92m\]\$\[\e[m\] "
}
PROMPT_COMMAND=prompt

# access Windows executables when System D enbaled
# https://github.com/microsoft/WSL/issues/8843
# sudo sh -c 'echo :WSLInterop:M::MZ::/init:PF > /usr/lib/binfmt.d/WSLInterop.conf'
alias pshell='powershell.exe'

export EDITOR=vim
alias list='ls -a -h -s -1 --color'
alias thesr='python3 -m thesr.thesr'
alias sqlformat='sqlformat --reindent --keywords upper --identifiers lower'
export TERM="xterm-256color"
export VIRTUAL_ENV_DISABLE_PROMPT=1
source ~/.venv/bin/activate # python venv
export winhome="/mnt/c/Users/JohnHupperts"
export AIRFLOW_HOME=~/airflow
# https://go.dev/doc/install
# core
export PATH=$PATH:/usr/local/go/bin
# packages
export PATH=$PATH:~/go/bin/

# Cirrus login
source ~/.bashrc_cirrus.sh

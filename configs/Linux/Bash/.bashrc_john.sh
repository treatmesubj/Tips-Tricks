# append 'source ~/.bashrc_john.sh' to ~/.bashrc ~/.bash_profile  ~/.bash_login
prompt() {
    # user@host: ~
    export PS1="\[\e[1;31m\]\u\[\e[m\]@\[\e[1;33m\]\h\[\e[m\]:\[\e[1;34m\]\w\[\e[m\]\r\n";

    # py-venv: /home/john/.venv
    if [[ $VIRTUAL_ENV ]]
    then
        export PS1+="\[\e[1;34m\]py-venv\[\e[m\]: \[\e[1;32m\](\$VIRTUAL_ENV)\[\e[m\]\r\n";
    fi;

    # branch: master
    branch=$(git branch 2> /dev/null | sed -e '/^[^*]/d')
    if [[ ! -z "$branch" ]]
    then
       export PS1+="\[\e[1;34m\]branch\[\e[m\]: \[\e[1;32m\]$branch\[\e[m\]\r\n";
    fi;

    # $
    # \[$(tput sgr0)\] can be goofy
    export PS1+="\[\e[1;92m\]\$\[\e[m\] "
}
PROMPT_COMMAND=prompt

# https://github.com/microsoft/WSL/issues/8843
# sudo sh -c 'echo :WSLInterop:M::MZ::/init:PF > /usr/lib/binfmt.d/WSLInterop.conf'
# access Windows executables when System D enbaled
alias pshell='powershell.exe'

alias list='ls -a -h -s -1 --color'
alias thesr='python3 -m thesr.thesr'
alias sqlformat='sqlformat --reindent --keywords upper --identifiers lower'
export TERM="xterm-256color"
export VIRTUAL_ENV_DISABLE_PROMPT=1
source ~/.venv/bin/activate # python venv
export winhome="/mnt/c/Users/JohnHupperts"
export AIRFLOW_HOME=~/airflow
# https://go.dev/doc/install
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:~/go/bin/

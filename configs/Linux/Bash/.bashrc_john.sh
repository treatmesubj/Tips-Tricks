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
    export PS1+="\[\e[1;92m\]\$\[\e[m\] \[$(tput sgr0)\]"
}
PROMPT_COMMAND=prompt
alias list='ls -a -h -s -1 --color'
alias pshell='powershell.exe'
alias thesr='python3 -m thesr.thesr'
export TERM="xterm-256color"
export VIRTUAL_ENV_DISABLE_PROMPT=1
source ~/.venv/bin/activate # python venv
export winhome="/mnt/c/Users/JohnHupperts"

export AIRFLOW_HOME=~/airflow

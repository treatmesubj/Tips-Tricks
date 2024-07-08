# append 'source ~/.bashrc_john.sh' to ~/.bashrc ~/.bash_profile ~/.bash_login
prompt() {
    # user@host:~
    long_path=$(dirs)
    short_path1=$(echo $long_path | sed "s/\/mnt\/c\/Users\/JohnHupperts/\$winhome/")
    export PS1="\[\e[1;31m\]\u\[\e[m\]@\[\e[1;93m\]\h\[\e[m\]:\[\e[1;34m\]\$short_path1\[\e[m\]\r\n";
    # export PS1="\[\e[1;31m\]\u\[\e[m\]@\[\e[1;33m\]\h\[\e[m\]:\[\e[1;34m\]\w\[\e[m\]\r\n";

    # py-venv: (~/.venv)
    if [[ $VIRTUAL_ENV ]]; then
        # short_path2=$(echo "$VIRTUAL_ENV" | sed "s/\/home\/rock/~/")
        short_path2=$(echo "$VIRTUAL_ENV" | sed "s/\/home\/john/~/")
        export PS1+="\[\e[1;36m\]§\[\e[m\] \[\e[1;92m\](\[\e[m\]\[\e[1;36m\]\$short_path2\[\e[m\]\[\e[1;92m\])\[\e[m\]\r\n";
    fi;

    # branch: * master
    # branch=$(git branch 2> /dev/null | sed -e '/^[^*]/d' | cut -d\  -f2-)
    branch=$(git branch 2> /dev/null | sed -n '/\* /s///p')
    if [[ $branch ]]; then
       export PS1+="\[\e[1;35m\]±\[\e[m\] \[\e[1;45m\]* \[\e[m\]\[\e[m\]\[\e[92;45m\]$branch\[\e[m\]\r\n";
    fi;

    if [[ $kubeps1 ]]; then
        kctxt="$(kubectl config current-context | cut -f1 -d"/" 2>/dev/null)"
        kns="$(kubectl config view --minify -o jsonpath='{..namespace}')"
        export PS1+="\[\e[44;97m\]Θ\[\e[m\] \[\e[3;93m\]$kctxt\[\e[m\]:\[\e[3;94m\]$kns\[\e[m\]\r\n"
    fi
    # $
    export PS1+="\[\e[1;92m\] \$ \[\e[m\]"
}
PROMPT_COMMAND=prompt

sizeup() {
    if [ $# -eq 1 ]  # file path arg
    then
        path=$(readlink -m $1)
        if [ -d $path ]  # directory
        then
            du -sh $path/* $path/.[^.]* 2>/dev/null | sort -hr
        else
            du -sh $path | sort -hr
        fi
    else
        du -sh * .[^.]* 2>/dev/null | sort -hr
    fi
}

randint() {
    if [ $# -eq 2 ]; then
        python -c "import random; print(random.randint($1, $2))"
    else
        echo "provide 2 integers as arguments"
    fi
}

pod_shell() {
    pod_name=$1
    shell=$2
    kubectl exec --stdin --tty $pod_name -- $shell || echo "usage: pod_shell <pod-name> <shell>"
}

tmux_clear_history() {
    for pane in $(tmux list-panes -F '#{pane_id}'); do
        tmux clear-history -t "${pane}"
    done
}

csv_filter() {
    # csv_filter <csv-filename or - (stdin)>
    local cludesym="~"
    local data=${1:-'-'}
    if [ "$data" = "-" ]; then
        local data=$(mktemp)
        cp /dev/stdin $data
    fi
    headers=$(head -1 < $data | csvquote)
    colname=$(
        echo $headers \
        | awk -v RS=',' '{print NR, $0}' \
        | grep . \
        | fzf --preview-window='down:80%' --preview "batcat --language 'csv' \
        --color=always --line-range=:50 $data"
    )
    colnum=$(echo $colname | cut -d ' ' -f 1)
    reggie=$(
        csvquote < $data \
        | awk -v colnum=$colnum -F, '!seen[$colnum]++ { print $colnum }' \
        | fzf --print-query --disabled --preview-window='down:80%' --preview \
        "awk -v colnum=$colnum -v reggie={q} -F, \
        '{ if (NR==1) { print \$0 } else if (\$colnum $cludesym reggie) { print \$0 } }' \
        < $data \
        | batcat --language 'csv' --color=always" | head -1
    )
    # echo $headers
    awk -v colnum=$colnum -v reggie=$reggie -F, \
    '{ if (NR==1) { print $0 } else if ($colnum '$cludesym' reggie) { print $0 } }' \
    < $data
}
alias csv-filter=csv_filter

# Windows
# access Windows executables when System D enbaled
# https://github.com/microsoft/WSL/issues/8843
# sudo sh -c 'echo :WSLInterop:M::MZ::/init:PF > /usr/lib/binfmt.d/WSLInterop.conf'
alias pshell='powershell.exe'
alias duckdb='duckdb.exe'
export winhome="/mnt/c/Users/JohnHupperts"

export EDITOR=nvim
alias nvimdiff='nvim -d'
export TERM="xterm-256color"
export VIRTUAL_ENV_DISABLE_PROMPT=1
source ~/.venv/bin/activate # python venv
# https://go.dev/doc/install
# core
export PATH=$PATH:/usr/local/go/bin
# packages
export PATH=$PATH:~/go/bin/

alias list='ls -ash -1 --color'
alias thesr='python3 -m thesr.thesr'
# ripgrep
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"
# sqlfmt is /usr/local/bin/sqlfmt (bash script)
# fzf
export FZF_DEFAULT_COMMAND='find .'  # hidden files
source /usr/share/doc/fzf/examples/key-bindings.bash  # fzf \C-r reverse search

# man pages in nvim
export MANPAGER='nvim +Man! -c "set nowrap"'
export MANWIDTH=999

nvim_fuzzfile() {
    f=$(
        fzf --preview 'batcat --color=always --theme="Monokai Extended" \
        --style=numbers --line-range=:500 -n {}' \
        --preview-window up --print-query | tail -1
    )
    echo $f
    nvim $f
}
nvim_fuzzline() {
    i=$(
        rg . --no-heading --hidden --line-number \
        | fzf --preview 'batcat --color=always --theme="Monokai Extended" \
        --style=numbers --line-range=:500 $(echo {} | cut -d ":" -f 1)' \
        --preview-window up
    )
    f=$(echo $i | cut -d ":" -f 1)
    l=$(echo $i | cut -d ":" -f 2)
    echo "$f:$l"
    nvim $f -c "norm ${l}gg"
}
alias nvim-fuzzfile=nvim_fuzzfile
alias nvim-fuzzline=nvim_fuzzline

# keys
source ~/.bashrc_keys.sh
# Cirrus login
source ~/.bashrc_cirrus.sh
# cluster login
source ~/.bashrc_cluster.sh

# bash vi mode
# see also ~/.inputrc
set -o vi
bind -m vi-command 'Control-l: clear-screen'
bind -m vi-insert 'Control-l: clear-screen'

# add bash history in real time
shopt -s histappend
PROMPT_COMMAND="history -a;$PROMPT_COMMAND"

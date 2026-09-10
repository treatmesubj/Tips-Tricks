#!/usr/bin/env bash
# append 'source ~/.bashrc_john.sh' to ~/.bashrc ~/.bash_profile ~/.bash_login
prompt() {
    # user@host:~
    short_home_path=${PWD/#$HOME/\~}
    short_home_path=${short_home_path/#\/mnt\/c\/Users\/JohnHupperts/\$winhome}
    export PS1="\[\e[1;31m\]\u\[\e[m\]@\[\e[1;93m\]\h\[\e[m\]:\[\e[1;34m\]\$short_home_path\[\e[m\]\r\n";

    # py-venv: (~/.venv)
    if [[ $VIRTUAL_ENV ]]; then
        venv=${VIRTUAL_ENV/#$HOME/\~}
        export PS1+="\[\e[1;36m\]§\[\e[m\] \[\e[1;92m\](\[\e[m\]\[\e[1;36m\]\$venv\[\e[m\]\[\e[1;92m\])\[\e[m\] ";
    fi;

    # branch: * master
    branch=$(git branch --show-current 2> /dev/null)
    if [[ $branch ]]; then
        export PS1+="\[\e[1;35m\]±\[\e[m\] \[\e[1;45m\]* \[\e[m\]\[\e[m\]\[\e[92;45m\]$branch\[\e[m\] ";
    fi;

    # Θ cluster:namespace
    kctxt="$(kubectl config current-context 2>/dev/null | cut -f1 -d"/")"
    if [[ $kctxt ]]; then
        kns="$(kubectl config view --minify -o jsonpath='{..namespace}')"
        export PS1+="\[\e[44;97m\]Θ\[\e[m\] \[\e[3;93m\]$kctxt\[\e[m\]:\[\e[3;94m\]$kns\[\e[m\] "
    fi
    # $
    export PS1+="\r\n\[\e[1;92m\]\$ \[\e[m\]"
}
PROMPT_COMMAND=prompt

sizeup() {
    # sizeup [relative-directory]
    if [ $# -eq 1 ]; then
        path=$(readlink -m "$1")
        if [ -d "$path" ]; then
            du -sh "$path"/* "$path"/.[^.]* 2>/dev/null | sort -hr
        else
            du -sh "$path" | sort -hr
        fi
    else
        du -sh * .[^.]* 2>/dev/null | sort -hr
    fi
}

randint() {
    if [ $# -eq 2 ]; then
        python -c "import random; print(random.randint($1, $2))"
    else
        echo "Usage: randint <lower-bound> <upper-bound>"
    fi
}

tmux_clear_history() {
    for pane in $(tmux list-panes -F '#{pane_id}'); do
        tmux clear-history -t "${pane}"
    done
}

csv_filter() {
    # csv_filter <file|stdin>
    # interactively filters a csv-column via case-insensitive regex
    local data=${1:-'-'}
    if [ "$data" = "-" ]; then
        local data=$(mktemp)
        cp /dev/stdin "$data"
    fi
    headers=$(head -1 < "$data" | csvquote)
    colname=$(
        awk -v RS=',' '{print NR, $0}' <<< "$headers" \
        | grep . \
        | fzf --prompt "column-to-filter: " \
        --preview-window='down:80%' --preview "batcat -p --language 'csv' \
        --color=always --line-range=:50 \"$data\""
    )
    colnum=$(cut -d ' ' -f 1 <<< "$colname")
    reggie=$(
        csvquote < "$data" \
        | awk -v colnum="$colnum" -F, '!seen[$colnum]++ { print $colnum }' \
        | fzf --prompt "$colname ~ " \
        --print-query --preview-window='down:80%' --preview \
        "csvquote < \"$data\" \
        | awk -v colnum=\"$colnum\" -v reggie={q} -F, \
        '{ IGNORECASE=1; if (NR==1) { print \$0 } else if (\$colnum ~ reggie) { print \$0 } }' \
        | batcat -p --language 'csv' --color=always" | head -1
    )
    csvquote < "$data" \
    | awk -v colnum="$colnum" -v reggie="$reggie" -F, \
    '{ IGNORECASE=1; if (NR==1) { print $0 } else if ($colnum ~ reggie) { print $0 } }'
}
alias csv-filter=csv_filter

hl() { grep --color=always -E "$1"; }

grepi() {
    # interactive case-insensitive grep
    # grepi file.txt
    local data=${1:-'-'}
    if [ "$data" = "-" ]; then
        local data=$(mktemp)
        cp /dev/stdin "$data"
    fi
    query=$(true | fzf --prompt 'grep -i ' --print-query \
        --preview-window='down:80%' \
        --preview "grep -i {q} --color=always \"$data\""
    )
    echo "grep -i \"$query\" \"$data\"" >&2
    grep -i "$query" "$data"
}

jqshape() {
    # shows shape/structure, all nodes of JSON in selector format
    jq -r 'tostream | select(has(1)) | ".\(first | map("[\(@json)]") | join("."))"' "$@"
}
export -f jqshape
jqshaper() {
    # shows shape/structure, all nodes of JSON in selector format
    jq -r 'tostream | select(has(1)) | ".\(first | map("[\(@json)]") | join(".")): \(last)"' "$@"
}
export -f jqshaper
jqi() {
    # interactive jq selector
    # jqi <file|stdin>
    local data=${1:-'-'}
    if [ "$data" = "-" ]; then
        local data=$(mktemp)
        cp /dev/stdin "$data"
    fi
    query=$(jqshape "$data" | fzf \
            --select-1 \
            --preview-window='down:50%' -q "." \
            --preview "jq {} \"$data\" | batcat \
                 -p --language 'json' --color=always --line-range=:50"
    )
    history -s "jq ${query@Q} $data"
    jq "$query" "$data"
}
jqir() {
    # interactive jq reverse value-to-selector
    # jqir <file|stdin>
    local data=${1:-'-'}
    if [ "$data" = "-" ]; then
        local data=$(mktemp)
        cp /dev/stdin "$data"
    fi
    query=$(true | fzf \
            --print-query \
            --preview-window='down:50%' \
            --preview "jqshaper \"$data\" \
                | awk -v reggie={q} -F: '\$2 ~ reggie'
    "
    )
    jqshaper "$data" | awk -v reggie="$query" -F: '$2 ~ reggie'
}
yqshape() {
    # shows shape/structure, all nodes of YAML in selector format
    # yq '.. | select(. == "*") | path | join(".")'
    echo "."
    yq eval '.. | select((tag == "!!map" or tag == "!!seq") | not) | path
        | map(
            (tag == "!!int") as $is_int
            | select($is_int) // "[\"" + (. | tostring) + "\"]"
        )
        | map(
            (tag != "!!int") as $is_int
            | select($is_int) // "[" + (. | tostring) + "]"
        )
        | join(".") | "." + .' "$@"
}
export -f yqshape
yqshaper() {
    # shows shape/structure, all nodes of YAML in selector format
    # yq '.. | select(. == "*") | path | join(".")'
    echo "."
    yq eval '.. | select((tag == "!!map" or tag == "!!seq") | not) | {(
        path
        | map(
            (tag == "!!int") as $is_int
            | select($is_int) // "[\"" + (. | tostring) + "\"]"
        )
        | map(
            (tag != "!!int") as $is_int
            | select($is_int) // "[" + (. | tostring) + "]"
        )
        | join(".") | "." + .
    ): .}' "$@"
}
export -f yqshaper
yqi() {
    # interactive yq selector
    # yqi <file|stdin>
    local data=${1:-'-'}
    if [ "$data" = "-" ]; then
        local data=$(mktemp)
        cp /dev/stdin "$data"
    fi
    query=$(yqshape "$data" | fzf \
            --select-1 \
            --preview-window='down:50%' -q "." \
            --preview "yq {} \"$data\" | batcat \
                -p --language 'yaml' --color=always --line-range=:50"
    )
    history -s "yq ${query@Q} $data"
    yq "$query" "$data"
}
yqir() {
    # interactive jq reverse value-to-selector
    # jqir <file|stdin>
    local data=${1:-'-'}
    if [ "$data" = "-" ]; then
        local data=$(mktemp)
        cp /dev/stdin "$data"
    fi
    query=$(true | fzf \
            --print-query \
            --preview-window='down:50%' \
            --preview "yqshaper \"$data\" \
                | awk -v IGNORECASE=1 -v reggie={q} -F: '\$2 ~ reggie'
    "
    )
    yqshaper "$data" | awk -v IGNORECASE=1 -v reggie="$query" -F: '$2 ~ reggie'
}

# Windows
# access Windows executables when System D enbaled
# https://github.com/microsoft/WSL/issues/8843
# sudo sh -c 'echo :WSLInterop:M::MZ::/init:PF > /usr/lib/binfmt.d/WSLInterop.conf'
alias pshell='powershell.exe'
alias pwdw='wslpath -w .'
alias duckdb='duckdb.exe'
export winhome="/mnt/c/Users/JohnHupperts"

export EDITOR=nvim
export TERM="xterm-256color"
export VIRTUAL_ENV_DISABLE_PROMPT=1
source ~/.venv/bin/activate # python venv
# https://go.dev/doc/install
# core
export PATH=$PATH:/usr/local/go/bin
# packages
export PATH=$PATH:~/go/bin/

alias list='ls -asht -1 --color -I . -I ..'
alias thesr='python3 -m thesr.thesr'
# ripgrep
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"
# sqlfmt is /usr/local/bin/sqlfmt (bash script)
# fzf
export FZF_DEFAULT_COMMAND='find .'  # hidden files
export FZF_DEFAULT_OPTS="--bind up:preview-up+preview-up,down:preview-down+preview-down"
source /usr/share/doc/fzf/examples/key-bindings.bash  # fzf \C-r reverse search

# man pages in nvim
export MANPAGER='nvim +Man! -c "set nowrap"'
export MANWIDTH=999

helpmebash() {
    # bash help for builtins, man-page stype in nvim
    local pattern=$1
    local page=$(help -m "$pattern")
    [[ -n "$page" ]] && nvim +Man! -c "set nowrap" <<< "$page"
}

gurl() {
    # from within a git repo, return a git URL for a file
    # Usage: gurl <relative-file-path> [branch]
    if [[ -n "$2" ]]; then
        branch="$2"
    else
        branch=$(git branch --show-current)
    fi

    local base=$(
        git config --get remote.origin.url \
        | sed -e "s+\.git$+/blob/$branch+" -e 's/^git@//' -e 's+com:+com/+'
    )
    [[ -z "$base" ]] && return 1

    local filepath=$(realpath "$1" | sed "s+$(git root)/++")
    [[ -z "$filepath" ]] && return 1

    echo "https://${base}/${filepath}"
}

alias nvimdiff='nvim -d'
# see also diff -u file1 file2 | delta --side-by-side
gitnvimdiff() {
    if [ $# -eq 0 ]; then
        echo -e "usage: git nvimdiff <rev-list> [[--] relative-path]]\n"
        echo "diff refs:"
        echo "  git nvimdiff master...HEAD"
        echo "diff ref..working-tree & edit working tree:"
        echo "  git nvimdiff master"
        echo "  git nvimdiff HEAD"
        echo "diff ref...HEAD + working-tree & edit working tree:"
        echo "  git nvimdiff \$(git merge-base master HEAD)"
        return 1
    fi
    rvl="$1"; shift
    files=$(git diff "$rvl" --name-only "$@")
    if [[ $(sed '/^$/d' <<< "$files" | wc -l) == 1 ]]; then
        f=$(head -1 <<< "$files")
        git difftool -y "$rvl" -- "$(git root)/$f"
    elif [[ $(sed '/^$/d' <<< "$files" | wc -l) == 0 ]]; then
        echo "identical: \"$rvl\" -- \"$@\""
    else
        while :; do
            f=$(fzf -0 --preview 'git diff '"$rvl"' -- '"$(git root)"'/{} | delta' --preview-window up,70%,~4,cycle --select-1 <<< "$files") || return 0
            git difftool -y "$rvl" -- "$(git root)/$f"
        done
    fi
}
export -f gitnvimdiff
nvimdiffsesh() {
    if [[ "$#" == 1 ]]; then
        local relfp=${1}
        fname=$(basename "${relfp}")
        tmpfname=/tmp/tmp-$fname
        cp "$relfp" "$tmpfname"
        nvimdiff "$tmpfname" "$relfp" \
            "+setlocal nomodifiable" "+foldopen!" \
            "+set diffopt-=hiddenoff" "+set diffopt-=closeoff" \
            "+0hide"  # RO ref buffer
    else
        echo "usage: nvimseshdiff <relative-file-path>"
    fi
}

diffleft() {
    if [ $# -eq 2 ]; then
        diff "$1" "$2" \
            --old-line-format='%L' \
            --new-line-format='' \
            --unchanged-line-format=''
    else
        echo "give me 2 items to diff"
    fi
}
diffright() {
    if [ $# -eq 2 ]; then
        diff "$1" "$2" \
            --old-line-format='' \
            --new-line-format='%L' \
            --unchanged-line-format=''
    else
        echo "give me 2 items to diff"
    fi
}

fuzzfile() {
    # fuzzfile | xargs -t nvim
    f=$(
        fzf --preview 'batcat --color=always --theme="Monokai Extended" \
        --style=header,numbers --line-range=:500 -P {}' \
        --preview-window="up:80%"
    ) || return $?
    echo "$f"
}
ff() {
    read -r -a c <<<$(f=$(fuzzfile) && xargs echo nvim <<<"$f")
    history -s "${c[@]}"
    echo "${c[@]}" && "${c[@]}"
}
fuzzline() {
    # fuzzline | xargs -t nvim
    i=$(
        rg . --no-heading --hidden --line-number \
        | fzf --nth 3.. -d ':' \
        --preview 'batcat --color=always --theme="Monokai Extended" \
        --style=numbers -P --highlight-line {2} {1}' \
        --preview-window="up:80%" --preview-window +{2}-5
    ) || return $?
    f=$(cut -d ":" -f 1 <<< "$i")
    l=$(cut -d ":" -f 2 <<< "$i")
    echo "$f +$l"
}
fl() {
    read -r -a c <<<$(f=$(fuzzline) && xargs echo nvim <<<"$f")
    history -s "${c[@]}"
    echo "${c[@]}" && "${c[@]}"
}

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
bind -m vi-command 'j: '  # bad habit
bind -m vi-command 'k: '  # bad habit
bind -m vi-insert 'Control-l: clear-screen'

# expand history substitution commands on enter
# e.g. !$ -> last arg
shopt -s histverify
# add bash history in real time
shopt -s histappend
PROMPT_COMMAND="history -a;$PROMPT_COMMAND"
# expand aliases for non-interactive shells
shopt -s expand_aliases

# no C-D bash EOF
set -o ignoreeof

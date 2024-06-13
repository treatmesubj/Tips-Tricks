# print lines that have Column(.*) or start with 'logical_type'
cat file.txt | awk '/Column\(.*\)|^logical_type/'

# for each line, print string that starts with 'stringstart'
cat file.txt | gawk 'match($0, /(stringstart\w*)/, a) {print a[1]}'

# find pod name
set orc_pod = kubectl get pods | awk '{ if ($1 ~ /orchestrator/ && $3 == "Running") { print $1 } }'


pwd | awk -F/ '{print $NF}'             # print last field
awk '{print $0}' infile.txt             # print each space/tab field-separated 'field'
awk '{print $1}' infile.txt             # print 1st space/tab field-separated 'field'
awk '{print $1,$3}' infile.txt          # print 1st & 3rd space/tab field-separated 'field'
ls -l | awk '{print $1,$NF}'            # print 1st & last space/tab field-demilited 'field'
cat /etc/passwd | awk -F ':' '{print $1"\t"$7}'  # print 1st & 7th colon field-separated 'field' with tab between

awk 'BEGIN{FS=":"; OFS="-"} {print $1, $7}' /etc/passwd 

awk -F "/" '/^\// {print $NF}' /etc/shells | uniq | sort

df | awk '/\/dev\/loop/ {print $1"\t"$2"\t"}'

ps -ef | awk '{ if($NF == "/bin/bash") print $0}'

awk 'BEGIN { for(i=1; i<=10; i++) print "i is", i;}'
awk 'BEGIN { OFS="="; for(i=1; i<=10; i++) print "i", i;}'


stringy="cool"
if awk -v var1="$stringy" 'index($0,var1)>0 {r=1;exit} END{exit r!=1}' ./file.txt
then
    # stuff
else
    # stuff
fi


# Add line numbers to text
awk '{ print NR, $0 }' OFS='\t' tmp.json
# 1       {
# 2         "a": 1,
# 3         "b": 1, "c": 1,
# 4         "d": 1, "e": 1
# 5       }


csv_filter() { 
    # csv-filename or - (stdin)
    local data=$1
    if [ -z "$data" ] || [ "$1" = "-" ]; then
        local data=$(mktemp)
        cp /dev/stdin $data
    fi
    headers=$(cat $data | head -1 | csvquote)
    colname=$(echo $headers | awk -v RS=',' '{print NR, $0}' | grep . | fzf)
    colnum=$(echo $colname | cut -d ' ' -f 1)
    reggie=$(echo '' | fzf --disabled --print-query --preview-window='down:90%' --preview "cat $data | awk -v colnum=$colnum -v reggie={q} -F, '(\$colnum ~ reggie)'")
    echo $headers
    cat $data | awk -v colnum=$colnum -v reggie=$reggie -F, '($colnum ~ reggie)'
}
alias csv-filter=csv_filter

head -1 data.csv | csvquote | awk -v RS=',' '{print NR, $0}' | fzf | cut -d ' ' -f 1
col=3; regfilt='IV'; awk -v col=$col -v regfilt=$regfilt -F, '{ if ($col ~ regfilt) { print $0 } }' data.csv

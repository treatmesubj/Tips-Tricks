# print lines that have Column(.*) or start with 'logical_type'
cat file.txt | awk '/Column\(.*\)|^logical_type/'

# for each line, print string that starts with 'stringstart'
cat file.txt | gawk 'match($0, /(stringstart\w*)/, a) {print a[1]}'




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
awk 'BEGIN { for(i=1; i<=10; i++) print "i is " i;}'
awk 'BEGIN { OFS="="; for(i=1; i<=10; i++) print "i", i;}'


stringy="cool"
if awk -v var1="$stringy" 'index($0,var1)>0 {r=1;exit} END{exit r!=1}' ./file.txt
then
    # stuff
else
    # stuff
fi

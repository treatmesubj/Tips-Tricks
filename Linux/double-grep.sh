for i in $(grep -irl stringy1); do printf "\n*********\n$i\n" && grep -i stringy2 $i; done

for i in $(rg -il stringy1); do printf "\n*********\n$i\n" && rg -i stringy2 $i; done

parallel rg -il findduplicate :::: <(rg -il addsurrogatekey) | wc -l


parallel --tty rg -g {1} -io {2} :::: <(rg -il wf360-prod) :::: wf360-dep-fields.txt
parallel --tty rg -g '{1}' -io "WF360_HR\.{2}\.*" :::: <(rg -il wf360-prod) :::: wf360-dep-tables.txt

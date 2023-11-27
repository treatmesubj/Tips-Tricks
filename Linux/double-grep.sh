for i in $(grep -irl stringy1); do printf "\n*********\n$i\n" && grep -i stringy2 $i; done

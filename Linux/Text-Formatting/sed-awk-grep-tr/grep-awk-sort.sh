# I used this to find all the error codes in a repo and sort them, to find greatest err code
rg -i -I -N stringstart | gawk 'match($0, /(stringstart\w*)/, a) {print a[1]}' | sort
rg -i -I -N E1 | gawk 'match($0, /(E1\w*)/, a) {print a[1]}' | sort
# E1237
# E1237
# E1238
# E1238
# E1240
# E1240
# E1241
# E1241

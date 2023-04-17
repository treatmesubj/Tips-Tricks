pip3 list --outdated | awk '{print $1}' | grep -vE "^(Package|---)" | xargs -n1 pip3 install --upgrade

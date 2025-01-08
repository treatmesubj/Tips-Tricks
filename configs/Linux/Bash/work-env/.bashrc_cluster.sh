#!/usr/bin/env bash
cluster_login() {
    nologin=$(ibmcloud ks cluster ls 2>&1 >/dev/null | grep FAILED)
    if [[ $nologin ]]; then
        ibmcloud login -r 'us-south' --apikey $ibmc_api_gcdo
    fi
    ibmcloud ks cluster ls

    cat << EOF

cluster - epm-finance-staging
    Staging namespace - CRD:        epm-kitt
    Staging namespace - Datamart:   epm-finance-datamart
    Staging namespace - FBI:        epm-raptors
    Staging namespace - FBI:        epm-raptors-sandbox

cluster - epm-finance-production
    Pre-Prod namespace - CRD:       epm-kitt-red
    Pre-Prod namespace - Datamart:  epm-finance-datamart-preprod
    Pre-Prod namespace - FBI:       epm-raptors-red
    Prod namespace - CRD:           epm-kitt-black
    Prod namespace - Datamart:      epm-finance-datamart
    Prod namespace - FBI:           epm-raptors-black

EOF

    echo -n -e "\033[92m\$\033[m "
    read -r -p "ibmcloud ks cluster config --cluster " cluster
    ibmcloud ks cluster config --cluster $cluster
    echo ""
    echo -n -e "\033[92m\$\033[m "
    read -r -p "kubectl config set-context --current --namespace=" namespace
    kubectl config set-context --current --namespace=$namespace

    kctxt="$(kubectl config current-context | cut -f1 -d"/" 2>/dev/null)"
    kns="$(kubectl config view --minify -o jsonpath='{..namespace}')"
    echo ""
    echo -e "\033[44;97mΘ\033[m $kctxt:$kns"

    export kubeps1=true
}

# useful kubectl aliases
alias k=kubectl
ksort="--sort-by=.status.startTime"
krunn="--field-selector=status.phase==Running"
kerr="--field-selector=status.phase!=Succeeded,status.phase!=Running"
kname="-o=custom-columns=NAME:.metadata.name"

# follow logs of running pod
kfl() {
    pod_grep=$1
    while :; do
        pods=$(
            k get pods --no-headers $krunn $ksort $kname \
            --sort-by=.status.startTime \
            | grep -E ".*$pod_grep.*"
        )
        if [ $(wc -l <<< "$pods") -gt 1 ]; then
            pod=$(echo "$pods" | fzf --height=10 --border=double --border-label="pods" --border-label-pos=3:bottom)
        else
            pod=$pods
        fi
        [[ $pod ]] && break
        echo -n .
        sleep 3
    done; echo $pod && kubectl logs -f $pod | tee /tmp/$pod.log
}

# read latest /tmp log in nvim
# usage:
#   newlog | xargs nvim
#   nvim $(newlog)
newlog() {
    ls -1t /tmp/*.log | head -1
}

# creates dir of logs for failed pods
kerrlogs() {
    ts=$(date +%s%3N)
    mkdir $ts
    k get pods $kname $ksort $kerr | tail -n +2 | xargs -I{} bash -c "kubectl logs {} > $ts/{}.log"
}

# human readable k8s cronjob expressions
kcrons() {
    pyscript="
import sys;
from cron_descriptor import get_description;
fmt = lambda str: str.split('\t')[0]+'\t'+get_description(str.split('\t')[1]);
print(*[fmt(line) for line in sys.stdin], sep='\n');
"
    k get cronjobs -o json \
    | jq -r '.items[] | {"name":.metadata.name, "schedule": .spec.schedule} | [.[]] | @tsv' \
    | python -c "$pyscript" \
    | column -t
}

# human readable cron expressions
hcron() {
    if [[ "$#" == 1 ]]; then
        python -c "import sys; from cron_descriptor import get_description; print(get_description('$1'))"
    else
        echo "usage: hcron \"* * * * *\""
    fi
}

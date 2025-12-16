#!/usr/bin/env bash
cluster_login() {
    case "$1" in
        -q|--quick)
            :
            ;;
        *)
            nologin=$(ibmcloud ks cluster ls 2>&1 >/dev/null | grep FAILED)
            if [[ $nologin ]]; then
                ibmcloud login -r 'us-south' --apikey $ibmc_api_edp
                # ibmcloud login --sso
            else
                ibmcloud target --choose-account
            fi
            echo -e "\n### Account's Clusters ###"
            ibmcloud ks cluster ls -q
            echo -e "\n##########################"
            ;;
    esac

    cat << EOF

EDP CLOUD Account's Clusters' Namespaces
----------------------------------------

epm-finance-staging
    Staging  CRD:       epm-kitt
    Staging  Datamart:  epm-finance-datamart
    Staging  FBI:       epm-raptors
    Sandbox  FBI:       epm-raptors-sandbox
    Staging  macgyver:  epm-macgyver
    Sandbox  macgyver:  macgyver-sandbox

epm-finance-production
    Pre-Prod  CRD:       epm-kitt-red
    Prod      CRD:       epm-kitt-black
    Pre-Prod  Datamart:  epm-finance-datamart-preprod
    Prod      Datamart:  epm-finance-datamart
    Pre-Prod  FBI:       epm-raptors-red
    Prod      FBI:       epm-raptors-black
    Pre-Prod  macgyver:  epm-macgyver-red
    Prod      macgyver:  epm-macgyver-black

EOF

    echo -n -e "\033[92m\$\033[m "
    read -r -p "ibmcloud ks cluster config --cluster " cluster
    ibmcloud ks cluster config --cluster "$cluster"
    echo ""
    echo -n -e "\033[92m\$\033[m "
    read -r -p "kubectl config set-context --current --namespace=" namespace
    kubectl config set-context --current --namespace="$namespace"

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
kip="-o=custom-columns=NAME:metadata.name,STATUS:status.phase,IP:status.podIP"

# autocompletion
# sudo apt install bash-completion
source <(kubectl completion bash)
complete -o default -F __start_kubectl k

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
        {
            [[ $pod ]] && echo "$pod" \
            && kubectl logs -f "$pod" | tee /tmp/"$pod".log \
            && break;
        } || {
            echo -n . && sleep 3;
        }
    done;
}

# usage:
#   k -n kube-system exec -it $(kpodname -A) -- bash
kpodname() {
    k get pods --no-headers $kname "$@" | fzf --height=10 --border=double --border-label="pods" --border-label-pos=3:bottom
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
    mkdir "$ts"
    k get pods $kname $ksort $kerr | tail -n +2 | xargs -I{} bash -c "kubectl logs {} > $ts/{}.log"
}

# human readable k8s cronjob expressions
kcrons() {
    echo -e "local:\t$(date +%r)"
    echo -e "UTC:\t$(date -u +%r)"
    echo "crons converted from UTC -> US/Central"
    pyscript="
import sys;
from cron_descriptor import get_description;
from crontzconvert import convert;
fmt = lambda str: str.split('\t')[0]+'\t'+get_description(convert(str.split('\t')[1],'UTC', 'US/Central'));
print(*[fmt(line) for line in sys.stdin], sep='\n');
"
    k get cronjobs -o json \
    | jq -r '.items[] | {"name":.metadata.name, "schedule": .spec.schedule} | [.[]] | @tsv' \
    | python -c "$pyscript" \
    | column -t
}

# human readable cron expressions
hcron() {
    echo -e "local:\t$(date +%r)"
    echo -e "UTC:\t$(date -u +%r)"
    echo "cron converted from UTC -> US/Central"
    pyscript="
import sys;
from cron_descriptor import get_description;
from crontzconvert import convert;
print(get_description(convert('$1','UTC', 'US/Central')));
"
    if [[ "$#" == 1 ]]; then
        python -c "$pyscript"
    else
        echo "usage: hcron \"* * * * *\""
    fi
}

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


kfl() {
    # follow logs
    pod_grep=$1
    while :; do
        pods=$(
            kubectl get pods --no-headers -o custom-columns=":metadata.name" --field-selector=status.phase==Running \
            --sort-by=.status.startTime \
            | grep -E ".*$pod_grep.*"
        )
        if [ $(wc -l <<< "$pods") -gt 1 ]; then
            pod=$(echo "$pods" | fzf)
        else
            pod=$pods
        fi
        [[ $pod ]] && break
        echo -n .
        sleep 3
    done; echo $pod && kubectl logs -f $pod | tee /tmp/$pod.log
}

# newlog | xargs nvim
# nvim $(newlog)
newlog() {
    ls -1t /tmp/*.log | head -1
}

alias k=kubectl
ksort="--sort-by=.status.startTime"
krunn="--field-selector=status.phase==Running"
kerr="--field-selector=status.phase!=Succeeded,status.phase!=Running"
kname="-o=custom-columns=NAME:.metadata.name"

# creates dir of logs for failed pods
kerrlogs() {
    ts=$(date +%s%3N)
    mkdir $ts
    k get pods $kname $ksort $kerr | tail -n +2 | xargs -I{} bash -c "kubectl logs {} > $ts/{}.log"
}


#!/usr/bin/env bash
cluster_login() {
    ibmcloud login -r 'us-south' --apikey $ibmc_api_gcdo
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


kubectl_fl() {
    # follow logs
    pod_grep=$1
    while :; do
        pod=$(
            kubectl get pods --field-selector=status.phase==Running \
            --sort-by=.status.startTime \
            | grep -E ".*$pod_grep.*-[0-9]{10}-driver" | tail -1 \
            | awk '{print $1}'
        )
        [[ $pod ]] && break
        echo -n .
        sleep 3
    done; kubectl logs -f $pod | tee $pod.log
}
alias k-fl=kubectl_fl

#!/usr/bin/env bash
alias login-us-south1-nonprod='oc login --username="$CIRRUS_USER" --password="$CIRRUS_PASS" --server=https://api.us-south1-dev.ciocloud.nonprod.intranet.ibm.com:6443 --insecure-skip-tls-verify=true'
alias login-us-south2-nonprod='oc login --username="$CIRRUS_USER" --password="$CIRRUS_PASS" --server=https://api.us-south2-dev.core.cirrus.ibm.com:6443 --insecure-skip-tls-verify=true'
alias login-us-south1-prod='oc login --username="$CIRRUS_USER" --password="$CIRRUS_PASS" --server=https://api.us-south1-prod.ciocloud.nonprod.intranet.ibm.com:6443 --insecure-skip-tls-verify=true'
alias login-us-east1-nonprod='oc login --username="$CIRRUS_USER" --password="$CIRRUS_PASS" --server=https://api.us-east1-dev.ciocloud.nonprod.intranet.ibm.com:6443 --insecure-skip-tls-verify=true'
alias login-us-east1-prod='oc login --username="$CIRRUS_USER" --password="$CIRRUS_PASS" --server=https://api.us-east1-prod.ciocloud.nonprod.intranet.ibm.com:6443 --insecure-skip-tls-verify=true'

cirrus_login() {
    options=(\
        "us-south1-nonprod"\
        "us-south2-nonprod"\
        "us-south1-prod"\
        "us-east1-nonprod"\
        "us-east1-prod"\
    )
    select opt in "${options[@]}"
    do
        case $opt in
        "us-south1-nonprod")
            login-us-south1-nonprod
            ;;
        "us-south2-nonprod")
            login-us-south2-nonprod
            ;;
        "us-south1-prod")
            login-us-south1-prod
            ;;
        "us-east1-nonprod")
            login-us-east1-nonprod
            ;;
        "us-east1-prod")
            login-us-east1-prod
            ;;
        *) echo "invalid option";;
        esac
        oc project
        break
    done
}

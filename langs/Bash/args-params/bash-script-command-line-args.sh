#!/usr/bin/env bash
( set -o posix ; set ) >/tmp/variables.before

set_param_var() {
    if ! [[ (-z "$2" || "$2" =~ ^-.+) ]]; then
        declare -g "$1=$2"
    else
        echo "parameter '$1' provided without a value"
        exit 1
    fi
}

while [[ "$#" -gt 0 ]]; do
    case "$1" in
        -p|--pipeline)
            set_param_var "pipeline" "$2" && shift 2; ;;
        -v|--validation)
            set_param_var "validation" "$2" && shift 2; ;;
        -j|--job_type)
            set_param_var "job_type" "$2" && shift 2; ;;
        -to|--trigger_only)
            trigger_only=true && shift; ;;
        -fo|--force_deploy)
            force_deploy=true && shift; ;;
        -cs|--clean_status)
            clean_status=true && shift; ;;
        -dm|--debug_mode)
            debug_mode=true && shift; ;;
        -vm|--verbose_mode)
            verbose_mode=true && shift; ;;
        -ei|--engine_image)
            set_param_var "engine_image" "$2" && shift 2; ;;
        --cool)
            set_param_var "cool" "$2" && shift 2; ;;
        *)
            echo "invalid parameter: '$1'"
            exit 1
            ;;
    esac
done

# validate script arguments
if [[ -z "$pipeline" && -z "$validation" ]]; then
    echo "Missing required parameter --pipeline or --validation"
    exit 1
elif [[ -n "$pipeline" && -n "$validation" ]]; then
    echo "Provide only --pipeline or --validation, not both"
    exit 1
elif [[ -z "$job_type" ]]; then
    echo "Missing required parameter --job_type"
    exit 1
elif [[ -n "$cool" && "$cool" != @(true|yes|yep) ]]; then
    echo "--cool value invalid: $cool"
    exit 1
fi

( set -o posix ; set ) >/tmp/variables.after
diff /tmp/variables.before /tmp/variables.after \
    --old-line-format='' \
    --new-line-format='%L' \
    --unchanged-line-format=''

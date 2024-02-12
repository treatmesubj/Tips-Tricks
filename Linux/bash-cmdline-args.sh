#!/bin/bash
set -e

# usage function, shows how to use the script
function usage {
    echo -e ""
    echo -e "usage: $programname [OPTIONS]"
    echo -e ""
    echo -e "Basic Options (Required):"
    echo -e "  --pipeline         name of the pipeline"
    echo -e "  --job_type         name of the jobType"
    echo -e "  --trigger_only     trigger pipelines previously deployed (true|false)"
    echo -e "  --force_deploy     force the pipeline deploy (true|false)"
    echo -e ""
    echo -e "Debug Options (Optional):"
    echo -e "  --debug_mode       enable/disable debug mode (true|false)"
    echo -e "  --engine_image     custom UIF engine image"
    echo -e ""
}
function stop {
    echo "Script failed: $1"
    exit 1
}
programname=$0

# parse script arguments
while [[ "$#" -gt 0 ]]; do
    if [[ $1 = @(--pipeline|--job_type|--trigger_only|--force_deploy|--debug_mode|--engine_image) ]]; then
        if ! [[ (-z "$2" || "$2" =~ ^--) ]]; then
            case $1 in
                --pipeline)
                    pipeline="$2" && shift 2; ;;
                --job_type)
                    job_type="$2" && shift 2; ;;
                --trigger_only)
                    trigger_only="$2" && shift 2; ;;
                --force_deploy)
                    force_deploy="$2" && shift 2; ;;
                --debug_mode)
                    debug_mode="$2" && shift 2; ;;
                --engine_image)
                    engine_image="$2" && shift 2; ;;
            esac
        else
            usage; stop "parameter '$1' provided without a value"
        fi
    else
        usage; stop "Unknown parameter passed: $1"
    fi
done

# validate script arguments
if [[ -z $pipeline ]]; then
    usage
    stop "Missing parameter --pipeline"
elif [[ -z $job_type ]]; then
    usage
    stop "Missing parameter --job_type"
fi

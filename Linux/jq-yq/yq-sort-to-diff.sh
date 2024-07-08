git checkout master && git pull
yq -i -P 'sort_keys(..)' dimensions/employee/job-category-dimension.yaml
kubectl get FactPipeline job-category-dimension --output=yaml | yq -P 'sort_keys(..)' > deployed.yaml
nvimdiff dimensions/employee/job-category-dimension.yaml deployed.yaml

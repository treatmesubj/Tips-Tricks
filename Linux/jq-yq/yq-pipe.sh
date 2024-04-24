# https://mikefarah.gitbook.io/yq/operators/pipe
# you can loop over entries in an array like below with pipe
yq '.subdags | .[] | .id' dags/deployable/maindags/facts/dag-main-headcount-monthly.yaml

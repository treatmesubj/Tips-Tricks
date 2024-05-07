# https://mikefarah.gitbook.io/yq/operators/pipe
# you can loop over entries in an array like below with pipe
yq '.subdags | .[] | .id' dags/deployable/maindags/facts/dag-main-headcount-monthly.yaml

# select a subset of yaml based on key-value, then pipe that to keep working
yq '.spec.templates | .[] | .extract | .[] | .connections | .[] | select (.connector == "taxonomy") | .query' facts/headcount/eid/templates/headcount-monthly-eid-template.yaml

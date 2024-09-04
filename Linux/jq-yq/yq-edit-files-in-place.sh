find . -type f -name "*.yaml" -exec yq -i 'with(.spec.jobs.[].extract.[] | select(.extractType == "default") | .connections.[] | select(.alias == "HR_SANDBOX"); .query = "sandbox/43729/" + .query)' {} ';'
# comments were removed
git add --patch .

find . -type f -name "*.yaml" -exec yq -i 'with(.spec.jobs.[].load.connections.[] | select(.alias == "HR_SANDBOX"); .query = "sandbox/43729/" + .query)' {} ';'
# sometimes less annoying
# find . -type f -name "*.yaml" -exec echo {} ';' -exec yq '.spec.jobs.[].extract.[].connections.[] | select (.alias == "HR_SANDBOX") | .alias' {} ';'
# comments were removed
git add --patch .

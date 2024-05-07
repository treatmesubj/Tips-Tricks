# all below from root of repo

# show pipelines changed in my branch
for f in $(git diff origin/master...HEAD --name-only | grep ^pipelines);\
    do yq '.metadata.name' $f; done | sort -u

# find & replace pipeline names in DAGs
find . -type f -exec sed -i'' -e 's/headcount-weekly-static-fact/headcount-weekly-static-fact-52964/g' {} /

# find & replace DAG IDs in DAGs
for f in $(git diff origin/master...HEAD --name-only | grep ^dags);\
    do dag_id=$(yq '.dag.dag_id' $f) && sed -i'' "s/$dag_id/$dag_id-52964/" $f; done

# find & replace main DAG ID
f="dags/deployable/maindags/facts/dag-main-headcount-monthly.yaml";\
    yq '.dag.dag_id' $f && sed -i'' "s/$dag_id/$dag_id-52964/" $f

# find & replace DAG IDs in main DAG, which have been changed in branch
main_dag="dags/deployable/maindags/facts/dag-main-headcount-monthly.yaml";\
for dag_id in $(sort\
        <(for f in $(git diff origin/master...HEAD --name-only | grep ^dags/deployable);\
            do dag_id=$(yq '.dag.dag_id' $f) && echo $dag_id | rev | cut -d"-" -f2-  | rev; done\
        )\
        <(yq '.subdags | .[] | .id' $main_dag) | uniq -d);\
    do sed -i'' "s/$dag_id/$dag_id-52964/" $main_dag; done

# copy DAGs from deployable dir to nondeployable
for f in $(git diff origin/master...HEAD --name-only | grep ^dags/deployable/);\
    do cp $f dags/nondeployable/facts/headcount/dm/; done

# find names of Db2 tables being loaded to in changed pipelines
for f in $(git diff origin/master...HEAD --name-only | grep ^pipelines);\
    do rg -ioI --no-line-number --no-heading '(query: )(EPM\w*\.\w+)' $f -or '$2'; done | sort -u

# find all raptors owned pipelines & templates
# cd pipelines/deployable
raptors_files="$(\
    for f in $(rg -il "slack: '@epm_raptors'"); do\
        metadata_name=$(yq '.metadata.name' $f) &&\
        rg -il "name: $metadata_name";\
    done\
)";\
echo "$raptors_files"

# find all raptors owned pipelines & templates & their extracted taxonomies
# cd pipelines/deployable
raptors_files="$(\
    for f in $(rg -il "slack: '@epm_raptors'"); do\
        metadata_name=$(yq '.metadata.name' $f) &&\
        rg -il "name: $metadata_name";\
    done\
)";\
for f in $raptors_files; do\
    yq '.spec.jobs | .[] | .extract | .[] | .connections | .[] | select(.connector == "taxonomy") | .query' $f\
    && yq '.spec.templates | .[] | .extract | .[] | .connections | .[] | select(.connector == "taxonomy") | .query' $f;\
done;

# find all tables loaded by raptors pipelines
# cd pipelines/deployable
loads="$(\
    for f in $(rg -il "slack: '@epm_raptors'"); do\
        yq '.spec.jobs | .[] | .load.connections | .[] | .query' $f;\
    done\
)";\
echo "$loads" | grep -E 'EPM\w*\.\w+' | sort -u

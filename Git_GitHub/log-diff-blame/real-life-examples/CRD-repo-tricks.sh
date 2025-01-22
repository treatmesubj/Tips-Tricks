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
# for f in $(git diff origin/master...HEAD --name-only | grep ^pipelines);\
#     do rg -ioI --no-line-number --no-heading '(query: )(EPM\w*\.\w+)' $f -r '$2'; done | sort -u
parallel --quote rg -ioI --no-line-number --no-heading '(query: )(\w*EPM\w*\.\w+)' {} -r '$2' :::: <(git diff origin/master...HEAD --name-only --relative) | sort -u

# find all raptors owned pipelines & templates
# cd pipelines/deployable
raptors_files="$(\
    for f in $(rg -il "slack: '@epm_raptors'"); do\
        metadata_name=$(yq '.metadata.name' $f) &&\
        rg -il "name: $metadata_name";\
    done\
)";\
echo "$raptors_files"

# anoother way of looking for tables
#!/usr/bin/env bash
rg -g "!tmp.sh" PSN_BASIC_ADDLOSS_COMP_IBM
rg -g "!tmp.sh" PSN_COMPENSATION_IBM
rg -g "!tmp.sh" PSN_EBD
rg -g "!tmp.sh" PSN_EBD_LGLNAME_IBM
rg -g "!tmp.sh" PSN_EXT_EBD
rg -g "!tmp.sh" PSN_LEARNING_CAREER_IBM
rg -g "!tmp.sh" PSN_LEARNING_SKILLS_IBM
rg -g "!tmp.sh" PSN_LEARNING_IBM
rg -g "!tmp.sh" PSN_SKILLS_IBM
rg -g "!tmp.sh" PSN_SPI_IBM
./tmp.sh > out.txt
rg -ioI --no-line-number --no-heading '(WF360\w*\.\w+)' out.txt | sort -u


# find extracted/loaded taxonomies
# cd pipelines/deployable
for f in $raptors_files; do\
    yq '.spec.jobs.[].extract.[].connections.[] | select(.credentials == "taxonomy*") | .query' $f\
    && yq '.spec.jobs.[].load.connections.[] | select(.credentials == "taxonomy*") | .query' $f\
    && yq '.spec.templates.[].extract.[].connections.[] | select(.credentials == "taxonomy*") | .query' $f\
    && yq '.spec.templates.[].load.connections.[] | select(.credentials == "taxonomy*") | .query' $f;\
done;

# find all pipelines & templates & their extracted/loaded taxonomies
# cd pipelines/deployable
for f in $(find . -type f -name '*.yaml'); do\
    yq '.spec.jobs.[].extract.[].connections.[] | select(.credentials == "taxonomy*") | .query' $f\
    && yq '.spec.jobs.[].load.connections.[] | select(.credentials == "taxonomy*") | .query' $f\
    && yq '.spec.templates.[].extract.[].connections.[] | select(.credentials == "taxonomy*") | .query' $f\
    && yq '.spec.templates.[].load.connections.[] | select(.credentials == "taxonomy*") | .query' $f;\
done | sort -u;


# find all raptors owned pipelines & templates & yaml-model-validate them
# cd pipelines/deployable
raptors_files="$(\
    for f in $(rg -il "slack: '@epm_raptors'"); do\
        metadata_name=$(yq '.metadata.name' $f) &&\
        rg -il "name: $metadata_name";\
    done\
)";\
for f in $raptors_files; do\
    if ! [[ "$f" =~ ^facts/rce/ ]]; then\
        yaml-model-validator pipeline $f;
    fi;
done;

# find all tables loaded by raptors pipelines
# cd pipelines/deployable
loads="$(\
    for f in $(rg -il "slack: '@epm_raptors'"); do\
        yq '.spec.jobs | .[] | .load.connections | .[] | .query' $f;\
    done\
)";\
echo "$loads" | grep -E 'EPM\w*\.\w+' | sort -u

# find all raptors owned pipelines & templates
# cd pipelines/deployable
raptors_files="$(\
    for f in $(rg -il "slack: '@epm_raptors'"); do\
        metadata_name=$(yq '.metadata.name' $f) &&\
        rg -il "name: $metadata_name";\
    done\
)";\
echo "$raptors_files" > raptors-files.txt
# for each file, check spec.owner and EID & DATAMART load.metadata
while read f; do
    echo "{ \"$f\" : {"
    echo "\".spec.owner\": "
    yq -o=json '.spec.owner // 0' $f
    echo ",\"eid.load.metadata\":"
    yq -o=json '.spec.jobs | [ .[] | select(.jobType == "*eid*") | .load.metadata ]' $f
    echo ",\"datamart-parquet.load.metadata\":"
    yq -o=json '.spec.jobs | [ .[] | select(.jobType == "*datamart*cos*" or .jobType == "*datamart-parquet*") | .load.metadata ]' $f;
    echo "}}"
done < raptors-files.txt | jq > raptors-files.json

# Local Dev Calendar Events
cd ~/CRD/pipelines/deployable/facts/headcount
find . -type f -exec sed -i'' 's/headcount_monthly_load/headcount_monthly_load_local/g' {} +
find . -type f -exec sed -i'' 's/Headcount Monthly Load$/Headcount Monthly Load Local/g' {} +




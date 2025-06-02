# without parents
mkdir split &&
    yq '.spec.templates.[]' headcount-monthly-eid-template.yaml -s '"./split/" + .templateName'

# with parents
mkdir split &&
    yq '[.spec.templates.[] as $i | ($i | parent(3) | .spec.templates = [$i]) as $f | $f].[] | split_doc' \
    headcount-monthly-eid-template.yaml \
    -s '"./split/" + .spec.templates.[0].templateName'
mkdir split &&
    yq '[.spec.templates.[] as $i | [$i | parent(3) | .spec.templates = [$i]].[0]].[] | split_doc' \
    headcount-monthly-eid-template.yaml \
    -s '"./split/" + .spec.templates.[0].templateName'

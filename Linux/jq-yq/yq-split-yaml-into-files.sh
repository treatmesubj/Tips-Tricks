mkdir split && yq '.spec.templates[]' headcount-monthly-eid-template.yaml -s '"./split/" + .templateName'

#########
# almost
yq '.spec.templates[] as $i | [$i | parent(3) | .spec.templates = $i]' headcount-monthly-eid-template.yaml | nvim -c "set ft=yaml"

# works
yq '[.spec.templates[] as $i | [$i | parent(3) | .spec.templates = $i][0]] | .[] | split_doc' headcount-monthly-eid-template.yaml | nvim -c "set ft=yaml"

# everything works
mkdir split && yq '[.spec.templates[] as $i | [$i | parent(3) | .spec.templates = [$i]][0]] | .[] | split_doc' headcount-monthly-eid-template.yaml -s '"./split/" + .spec.templates[0].templateName'

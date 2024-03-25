mkdir split && yq '.spec.templates[]' headcount-monthly-eid-template.yaml -s '"./split/" + .templateName'

#!/usr/bin/env bash

# lame
mv employee-dimension.yaml my-employee-dimension.yaml
git checkout master employee-dimension.yaml

# nice
git show <ref>:<rel-file-path>
git show master:./employee-dimension.yaml > master-employee-dimension.yaml

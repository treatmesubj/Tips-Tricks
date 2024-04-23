# https://mikefarah.gitbook.io/yq/usage/properties
yq -o=props --properties-array-brackets head-count-fact.yaml | nvim -

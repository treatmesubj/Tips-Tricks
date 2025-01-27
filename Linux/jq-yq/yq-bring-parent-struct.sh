# https://mikefarah.gitbook.io/yq/operators/path#set-path-to-prune-deep-paths


# gets your select() struct, but nests it in its minimal parent struct
# basically gets the full struct, but filtered down to your select() criteria

# filters dimension_config to entries & sub-dims using real dimension
dim="PERIOD_V4_DIMENSION_FINANCE";\
    yq '(.[].subdims.[] | select(.SKAPI.dim_name_skapi == "'"$dim"'")) as $i ireduce({}; setpath($i | path; $i))' dimension_config-epm_raptors_sandbox_ui.json -o json\
    | nvim -c "set ft=json"

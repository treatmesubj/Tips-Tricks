## Looking for current table DDL
```bash
cd datamart-model
rg -il EPM_FINANCE.FACT_BUDGET_FORECAST_REVENUE_COST_EXPENSE\
    -g '!old_releases/'\
    -g '!releases/'\
    -g '!pre-release/'\
    --iglob '**.ddl'
```


## tables I've changed in my branch
```bash
# tables
parallel --quote rg -ioI --no-line-number --no-heading '(CREATE\s*TABLE\s*)(\w*EPM\w*\.\w+)' {} -r '$2' :::: <(git diff origin
/main...HEAD --name-only ':!datamart-model/pre-release') | sort -u
# tables, views, aliases
parallel --quote rg -ioI --no-line-number --no-heading '(CREATE.*\s)(\w*EPM\w*\.\w+)' {} -r '$2' :::: <(git diff origin/main...HEAD --name-only ':!datamart-model/pre-release') | sort -u
```

okay based on this grepping around the `EPM/infrastructure` repo and looking at
the voldemort labeled PRs
```bash
$ rg -ioI --no-line-number --no-heading 'EPM\w*\.\w+\s' -g 'old_releases/2023/voldemort/**' | sort -u > ~/voldemort-tables.txt
$ rg -ioI --no-line-number --no-heading 'EPM\w*\.\w+\s' -g '!old_releases/' -g '!releases/' -g '!pre-release/' | sort -u > ~/all-tables.txt
$ for f in $(cat ~/voldemort-tables.txt); do echo "$f | $(rg -il """$f\s""" -g '!old_releases/' -g '!releases/' -g '!pre-release/' --iglob '**.ddl')"; done
EPM.DIM_EMPLOYEE | enterprise_dimensions/FACT_PRE_SALES_CADENCE_DETAIL.DDL
enterprise_dimensions/dim_employee.ddl
EPM.DIM_GTM_ROLE |
EPM.DIM_PRODUCT_LINE |
EPM_HR.DIM_GTM_ROLE | HR/dimensions/dim_gtm_role.ddl
EPM_HR.DIM_HEAD_COUNT_ATTRIBUTES | HR/dimensions/dim_head_count_attributes.ddl
EPM_HR.DIM_PRODUCT_LINE | HR/dimensions/dim_product_line.ddl
EPM_HR.FACT_HEAD_COUNT_MONTHLY_DYNAMIC | HR/facts/fact_head_count_monthly_dynamic.ddl
EPM_HR.FACT_HEAD_COUNT_MONTHLY_DYNAMIC_PERIOD_TO_PERIOD | HR/facts/fact_head_count_monthly_dynamic_period_to_period.ddl
EPM_HR.FACT_HEAD_COUNT_MONTHLY_STATIC | HR/facts/fact_head_count_monthly_static.ddl
EPM_HR.FACT_HEAD_COUNT_MONTHLY_STATIC_PERIOD_TO_PERIOD | HR/facts/fact_head_count_monthly_static_period_to_period.ddl
EPM_HR.FACT_HEAD_COUNT_WEEKLY_DYNAMIC | HR/facts/fact_head_count_weekly_dynamic.ddl
EPM_HR.FACT_HEAD_COUNT_WEEKLY_STATIC | HR/facts/fact_head_count_weekly_static.ddl
EPM_SALES.DIM_SALES_INCENTIVES_PLAN | enterprise_dimensions/dim_sales_incentives_plan.ddl
```
looks like all tables touched by voldemort are in "main path" except
`EPM.DIM_GTM_ROLE` & `EPM.DIM_PRODUCT_LINE`
however, there are also corresponding `EPM_HR.DIM_GTM_ROLE` & `EPM_HR.DIM_PRODUCT_LINE`
which I see have PRs from the voldemort guy in October '23
- `datamart-model/HR/dimensions/dim_gtm_role.ddl`
- `datamart-model/HR/dimensions/dim_product_line.ddl`
Grepping for these tables in the repo history show `EPM.DIM_GTM_ROLE` &
`EPM.DIM_PRODUCT_LINE`  show they were only ever merged into main in the
`datamart-model/releases/voldemort` directory
```bash
$ git log -G EPM\.DIM_GTM_ROLE --oneline --merges --first-parent --name-only
fb7ee7ab1 Merge pull request #946 from Dzmitry-Pasternak1/EPMKEY-44154_DAY---Voldemort-Release-DDL-Hotfix
datamart-model/releases/voldemort/creates/dim_gtm_role_old.ddl
98ec0118f Merge pull request #735 from Dzmitry-Pasternak1/EPMKEY-42086_REL-DDL-Preparing-for-HC-and-RDM-dimensions
datamart-model/releases/voldemort/creates/dim_gtm_role_old.ddl

$ git log -G EPM\.DIM_PRODUCT_LINE --oneline --merges --first-parent --name-only
98ec0118f Merge pull request #735 from Dzmitry-Pasternak1/EPMKEY-42086_REL-DDL-Preparing-for-HC-and-RDM-dimensions
datamart-model/releases/voldemort/creates/dim_product_line_old.ddl
```
It was probably decided that these are not "enterprise dimensions"
So I think all voldemort stuff is accounted for in "main path"

also if I do
```bash
$ for f in $(cat ~/voldemort-tables.txt); do echo "$(rg -il "$f\s" -g '!old_releases/' -g '!releases/' -g '!pre-release/' --iglob '**.ddl')"; done > ~/files.txt
```
to find the DDL files in the "main path" for the tables in the voldemort release
and then check the git log for the last PR/commits to those files to verify if they've been updated since voldemort
```bash
$ for f in $(cat ~/files.txt); do git log -1 --merges --first-parent --name-only -- $f; done
```
I find all the "main path" DDLs have been updated since voldemort
and most importantly I find this PR: `EPMKEY-44511_DAY---Sync-up-DDLs-in-PROD---POST-VOLDEMORT-Release`
so looks to me like Voldemort is for sure good

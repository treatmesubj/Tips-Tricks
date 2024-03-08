import pandas as pd

# joins
# df3 = df1.merge(df2, on='CNUM', how='left')
# df3 = df1.merge(df2, how='left', left_on='CNUM', right_on='CNUM')
# https://pandas.pydata.org/docs/reference/api/pandas.DataFrame.merge.html

df = pd.read_csv("./my.csv")
df.head()
len(df.index)

df_filt = df.loc[(df.COL1 != "blah") & (df.COL2 == 1) & (df.COL3 == 1)]
len(df_filt.index)
df_filt.to_csv("./my_filtered.csv")


# SELECT SK_EMPLOYEE_CNUM, CNUM
# FROM EPM.DIM_EMPLOYEE
# WHERE FLAG_ACTIVE_ROW = True
# -- ORDER BY REVISION DESC
# WITH UR;
employee = pd.read_csv("./employee.csv")

hc = pd.read_csv("./hc-02-24.csv")
# SELECT DISTINCT CNUM, HIRE_DATE
# FROM WF360_HR.DIM_EMPLOYEE_PSN_EBD
wf360 = pd.read_csv("./wf360-hiredate.csv")

hc_employee = hc.merge(
    employee, how="left", left_on="EMPLOYEE_CNUM_KEY", right_on="SK_EMPLOYEE_CNUM"
)
hc_employee_wf360 = hc_employee.merge(
    wf360, how="left", left_on="CNUM", right_on="CNUM"
)
hc_employee_wf360.to_csv("hc_emp_wf360.csv")

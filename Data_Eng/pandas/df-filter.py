import pandas as pd


df = pd.read_csv("./my.csv")
df.head()
len(df.index)

df_filt = df.loc[(df.COL1 != "blah") & (df.COL2 == 1) & (df.COL3 == 1)]
# df_filt = df.loc[(df.RDM_RESOURCE_POOL_TAG != 'Non-RDM') & (df.QUARTER == 1) & (df.MONTH == 1)]
len(df_filt.index)
df_filt.to_csv("./my_filtered.csv")

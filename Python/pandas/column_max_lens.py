import pandas as pd


df = pd.read_excel('data.xlsx')
for col in df:
    print(col, "->", df[col].astype(str).str.len().max())

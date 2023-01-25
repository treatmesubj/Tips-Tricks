import pandas as pd
import os


path = r"C:\Users\JohnHupperts\Desktop\ESG Social Metrics"

filenames = []
for currentpath, folders, files in os.walk(path):
    for file in files:
        if file.endswith(".xlsx"):
            filenames.append(os.path.join(currentpath, file))

df_list = []
for file in filenames:
    print(file)
    df_list.append(pd.read_excel(file, sheet_name=0, skiprows=2, header=None))

final_df = pd.concat(df_list, ignore_index=True)
# final_df.to_excel("colidated_files.xlsx", index=False)

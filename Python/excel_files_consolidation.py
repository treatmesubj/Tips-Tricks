import pandas as pd
import glob
import os


path = r"C:\Users\JohnHupperts\Desktop\ESG Social Metrics"
filenames = glob.glob(os.path.join(path, "*.xlsx"))

# df_list = [pd.read_excel(file, sheet_name="Sheet1", skiprows=2, header=None) for file in filenames]
df_list = [pd.read_excel(file, sheet_name=0, skiprows=2, header=None) for file in filenames]

final_df = pd.concat(df_list, ignore_index=True)
# final_df.to_excel("colidated_files.xlsx", index=False)

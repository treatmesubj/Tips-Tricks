import pandas as pd
from sqlalchemy import create_engine


excel_file = r"C:\Users\JohnHupperts\Documents\GCDO_CEDP\Projects\Ecosystems_360_Notes\AccessHub\Access_Provisioning_Data\EDS_VW_BUSINESS_MEASUREMENT_UNIT_DIMENSION.xlsx"
sheet_name = "EDS_VW_BUSINESS_MEASUREMENT_UNI"

df = pd.read_excel(excel_file, sheet_name=sheet_name)
engine = create_engine('sqlite://', echo=False)
df.to_sql('TABBY', engine, if_exists='replace')
""" table name: TABBY """

results = engine.execute("SELECT DISTINCT UNIT_CD, SUB_UNIT_CD, DIVISION_GROUP_CD, DIVISION_CD FROM TABBY").fetchall()
results_df = pd.DataFrame(results, columns=['UNIT_CD', 'SUB_UNIT_CD', 'DIVISION_GROUP_CD', 'DIVISION_CD'])
results_df.to_excel("query_results.xlsx", index=False)


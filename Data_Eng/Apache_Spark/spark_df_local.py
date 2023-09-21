# collect DB Spark df into local memory Spark df
# so future operations are faster
df_local = spark.createDataFrame(data=df.collect(), schema=df.schema)
df_local.createOrReplaceTempView("MY_VIEW")
print(df_local.head())
print(df_local.count())

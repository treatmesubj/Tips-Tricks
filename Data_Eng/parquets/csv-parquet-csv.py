from pyspark.sql import SparkSession


spark = SparkSession.builder.getOrCreate()

# SparkSession.DataFrameReader.options(**options).csv("path.csv")
df = spark.read.option("header", True).csv("data.csv")
df.printSchema()
df.head()
# pyspark-df.DataFrameWriter.parquet("path.parquet")
df.write.parquet("data.parquet")


# SparkSession.DataFrameReader.parquet("path.parquet")
df = spark.read.parquet("data.parquet")
df.printSchema()
df.head()
# pyspark-df.DataFrameWriter.csv("path.csv")
df.write.csv("data.csv")

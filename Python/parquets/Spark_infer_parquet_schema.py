table = spark.read.parquet("/mnt/c/Users/JohnHupperts/Desktop/myfile.parquet", header=True, inferSchema=True)
table.printSchema()
ddl = spark.sparkContext._jvm.org.apache.spark.sql.types.DataType.fromJson(table.schema.json()).toDDL()

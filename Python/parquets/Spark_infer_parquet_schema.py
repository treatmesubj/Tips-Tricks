table = spark.read.parquet("/mnt/c/Users/JohnHupperts/Desktop/myfile.parquet", header=True, inferSchema=True)
table.printSchema()

# https://spark.apache.org/docs/latest/api/python/reference/pyspark.sql/functions.html
# $ pyspark
# Welcome to
#       ____              __
#      / __/__  ___ _____/ /__
#     _\ \/ _ \/ _ `/ __/  '_/
#    /__ / .__/\_,_/_/ /_/\_\   version 3.4.0
#       /_/
#
# Using Python version 3.11.2 (main, Mar 13 2023 12:18:29)
# Spark context Web UI available at http://172.31.63.35:4040
# Spark context available as 'sc' (master = local[*], app id = local-1704408126365).
# SparkSession available as 'spark'.

from rich import pretty, print; pretty.install();
from pyspark.sql import functions as F
from inspect import getmembers, isfunction
exposed_methods = dict(getmembers(F, isfunction))
funcs = [key for key in exposed_methods.keys()]
print(funcs)

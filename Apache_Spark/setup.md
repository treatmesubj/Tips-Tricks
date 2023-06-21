0. Probably create a [Python Virtual Environment](../configs/Python/venv) first
1. Install Java: `sudo apt install openjdk-11-jdk`
2. Install PySpark: `pip3 install pyspark`

## Old way
- [Download Spark](https://spark.apache.org/downloads.html)
- Check the downloaded package's keys & signatures
    - `curl https://downloads.apache.org/spark/KEYS -O`
    - `curl https://downloads.apache.org/spark/spark-3.3.1/spark-3.3.1-bin-hadoop3.tgz.asc -O`
    - `gpg --import KEYS`
    - `gpg --verify spark-3.3.1-bin-hadoop3.tgz.asc`


```
$ pyspark
Python 3.8.10 (default, Nov 14 2022, 12:59:47)
[GCC 9.4.0] on linux
Type "help", "copyright", "credits" or "license" for more information.
Welcome to
      ____              __
     / __/__  ___ _____/ /__
    _\ \/ _ \/ _ `/ __/  '_/
   /__ / .__/\_,_/_/ /_/\_\   version 3.3.1
      /_/

Using Python version 3.8.10 (default, Nov 14 2022 12:59:47)
Spark context Web UI available at http://9.65.215.136:4040
Spark context available as 'sc' (master = local[*], app id = local-1674594889273).
SparkSession available as 'spark'.
>>>
```


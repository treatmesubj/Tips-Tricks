#!/usr/bin/env python3
from pyspark.sql import SparkSession
from pyspark.conf import SparkConf
from pyspark.sql.types import DateType, TimestampType
from pyspark.sql.functions import date_format
import os
from rich import pretty, print

pretty.install()


def simple_get_df(
    spark_session,
    jdbc_url: str,
    user: str,
    password: str,
    sql_statement: str,
    driver: str = "com.ibm.db2.jcc.DB2Driver",
):
    spark_sql_statement = f"({sql_statement}) as tab"

    df_config = (
        spark_session.read.format("jdbc")
        .option("url", jdbc_url)
        .option("driver", driver)
        .option("user", user)
        .option("password", password)
        .option("dbtable", spark_sql_statement)
    )
    df = df_config.load()
    return df


def ETL_get_df(
    spark_session,
    fields: str,
    schema_table: str,
    jdbc_url: str,
    user: str,
    password: str,
    driver: str = "com.ibm.db2.jcc.DB2Driver",
    order_fields: str = None,
    partitions: int = None,
    where: str = None,
    order_by: str = None,
    fetch_first: str = None,
):
    statement = f"(select {fields} "

    if order_fields and partitions:
        statement += f", mod(rownumber() over(order by {order_fields}), {partitions}) mod_rn_partition_extra "

    statement += f"from {schema_table} "

    if where:
        statement += f"{where} "

    if order_by:
        statement += f"{order_by} "

    if fetch_first:
        statement += f"{fetch_first} "

    statement += ") as tab"
    print(f"statement: {statement}")

    df_config = (
        spark_session.read.format("jdbc")
        .option("url", jdbc_url)
        .option("driver", driver)
        .option("user", user)
        .option("password", password)
        .option("dbtable", statement)
    )
    if partitions:
        df_config = (
            df_config.option("partitionColumn", "mod_rn_partition_extra")
            .option("lowerBound", 0)
            .option("upperBound", partitions)
            .option("numPartitions", partitions)
            .option("fetchsize", "10000")
        )
    df = df_config.load()
    if partitions:
        df = df.drop("mod_rn_partition_extra")

    return df


if __name__ == "__main__":
    conf = SparkConf()
    conf.set(
        "spark.jars",
        "/mnt/c/Users/JohnHupperts/jdbc_sqlj/db2jcc4.jar,/mnt/c/Users/JohnHupperts/jdbc_sqlj/license/db2jcc_license_cisuz.jar,/mnt/c/Users/JohnHupperts/jdbc_sqlj/license/db2jcc_license_cu.jar,",
    )
    conf.set("spark.driver.memory", "8g")  # extra mem
    spark = SparkSession.builder.config(conf=conf).getOrCreate()

    assert os.getenv("db_user"), "no db_user env var"
    assert os.getenv("db_pw"), "no db_pw env var"

    df = simple_get_df(
        spark_session=spark,
        jdbc_url="jdbc:db2://db2w-host:50001/BLUDB:sslConnection=true;sslTrustStoreLocation=/mnt/c/Users/JohnHupperts/ibm-truststore.jks;sslTrustStorePassword=changeit;",
        # apiKey method
        #   jdbc_url="jdbc:db2://db2w-host:50001/BLUDB:sslConnection=true;pluginName=IBMIAMauth;securityMechanism=15;apiKey=<apikey>;",
        #   user=""
        #   password=""
        user=os.getenv("db_user"),
        password=os.getenv("db_pw"),
        sql_statement="""
        SELECT *
        FROM SYSIBM.SYSTABLES
        """,
    )
    df.createOrReplaceTempView("df")

    print(df.head())
    print(df.schema)

    def query_again(query):
        df = simple_get_df(
            spark_session=spark,
            jdbc_url="jdbc:db2://db2w-rjouofk.us-east.db2w.cloud.ibm.com:50001/BLUDB:sslConnection=true;",
            user=os.getenv("db_user"),
            password=os.getenv("db_pw"),
            sql_statement=query,
        )
        return df

    # SparkSession.DataFrameReader.options(**options).csv("path.csv")
    # spark.read.option("header", True).csv("path.csv")

    # pyspark-df.DataFrameWriter.parquet("path.csv")
    df.coalesce(1).write.mode("overwrite").option("header", "true").csv("df.csv")

    # sub_df = spark.sql(
    #     """
    #     SELECT *
    #     FROM df
    #     LIMIT 50;
    #     """
    # )
    # print(sub_df.head())

    # # fixing up types for conversion to Pandas DF
    # for field in sub_df.schema:
    #     if field.dataType in (DateType(), TimestampType()):
    #         sub_df = sub_df.withColumn(field.name, date_format(field.name, "MM-dd-yyy"))

    # # version 1
    # sub_df.toPandas().to_excel("sub_df.xlsx", engine="xlsxwriter")
    # # version2
    # # fix utf-8 char problems
    # pd_sub_df = sub_df.toPandas().applymap(
    #     lambda x: (
    #         x.encode("unicode_escape").decode("utf-8") if isinstance(x, str) else x
    #     )
    # )
    # pd_sub_df.to_excel("sub_df.xlsx")

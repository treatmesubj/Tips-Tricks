from pyspark.sql import SparkSession
from pyspark.conf import SparkConf
from pyspark.sql.types import DateType, TimestampType
from pyspark.sql.functions import date_format
import os


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
        "/mnt/c/Users/JohnHupperts/Documents/JARs/db2jcc4.jar,/mnt/c/Users/JohnHupperts/Documents/JARs/db2jcc_license_cisuz.jar,/mnt/c/Users/JohnHupperts/Documents/JARs/db2jcc_license_cu.jar,",
    )
    spark = SparkSession.builder.config(conf=conf).getOrCreate()

    assert os.getenv("db_user"), f"no db_user env var"
    assert os.getenv("db_pw"), f"no db_pw env var"

    df = simple_get_df(
        spark_session=spark,
        fields="*",
        schema_table="SYSIBM.SYSTABLES",
        jdbc_url="jdbc:db2://db2w-host:50001/BLUDB:sslConnection=true;sslTrustStoreLocation=/home/john/ibm-truststore.jks;sslTrustStorePassword=changeit;",
        user=os.getenv("db_user"),
        password=os.getenv("db_pw"),
    )
    df.createOrReplaceTempView("df")

    sub_df = spark.sql(
        """
        SELECT *
        FROM df
        LIMIT 50;
        """
    )
    print(sub_df.head())

    # fixing up types for conversion to Pandas DF
    for field in sub_df.schema:
        if field.dataType in (DateType(), TimestampType()):
            sub_df = sub_df.withColumn(field.name, date_format(field.name, "MM-dd-yyy"))

    # version 1
    sub_df.toPandas().to_excel("sub_df.xlsx", engine="xlsxwriter")
    # version2
    # fix utf-8 char problems
    pd_sub_df = sub_df.toPandas().applymap(
        lambda x: x.encode("unicode_escape").decode("utf-8")
        if isinstance(x, str)
        else x
    )
    pd_sub_df.to_excel("sub_df.xlsx")

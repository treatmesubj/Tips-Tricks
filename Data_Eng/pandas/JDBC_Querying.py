import jaydebeapi  # https://github.com/baztian/jaydebeapi  # https://peps.python.org/pep-0249/
import pandas as pd


def query_to_df(db_cursor, query):
    """
    db_cursor: jaydebeapi cursor object
    query: string object; SQL query
    """
    db_cursor.execute(query)
    col_headers = [field[0] for field in db_cursor.description]
    result = db_cursor.fetchall()

    df = pd.DataFrame(result, columns=col_headers)
    return df


if __name__ == "__main__":
    db_dict = {
        "host": "",
        "port": "",
        "database": "",
        "username": "",
        "password": "",
        "driver_path": "",
    }

    db_connection = jaydebeapi.connect(
        jclassname="com.ibm.db2.jcc.DB2Driver",
        url=f"jdbc:db2://{db_dict['host']}:{db_dict['port']}/{db_dict['database']}:"\
            f"user={db_dict['username']};"\
            f"password={db_dict['password']};"\
            "sslConnection=true;"\
            "sslCertLocation=/home/wsuser/work/cert.cert;"\
            # "sslTrustStoreLocation=/home/wsuser/work/ibm-truststore.jks;"\
            # "sslTrustStorePassword=changeit;"\
            "enableClientAffinitiesList=1;"\
            "enableSeamlessFailover=true;"\
            "clientRerouteAlternatePortNumber=443;"\
            f"clientRerouteAlternateServerName={db_dict['host']};",
        # driver_args = {},
        jars=f"{db_dict['driver_path']}",
    )
    db_cursor = db_connection.cursor()

    df = query_to_df(
        db_cursor,
        """
SELECT *
    FROM (
        VALUES ('Hello world')
    ) t1 (col1)
    WHERE 1 = 1
""",
    )
    df.head()

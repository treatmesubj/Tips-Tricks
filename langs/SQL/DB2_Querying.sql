/* 
DB2 CLI
    db2cli execsql -dsn SMS -user ***** -passwd ***** -inputsql test.sql -statementdelimiter ';' -outfile test_results.csv
    db2cli validate -connect -dsn SMS -user ***** -passwd ****
    db2cli validate -dsn SMS -connect -odbcdsn -user ****** -passwd ****

QMF Ad Hoc Queries
    # from run command console:
            RESET QUERY
    # save .sql text file as .vry file
    # ini file: C:\ProgramData\IBM\DB2\IBMDBCL1\cfg\db2cli.ini
*/

/* Looking for Schemas */
SELECT *
FROM SYSCAT.SCHEMATA
WHERE SCHEMANAME = 'BLAH'
WITH UR;

/* Looking for Tables */
SELECT NAME, CREATOR, TYPE, CTIME, BASE_NAME, BASE_SCHEMA, LAST_REGEN_TIME, ALTER_TIME, LASTUSED
FROM SYSIBM.SYSTABLES
WHERE (
    NAME IN 'BLAH'
    OR NAME IN 'BLEH'
    OR NAME IN 'BLEK'
)
WITH UR;

SELECT NAME, CREATOR, TYPE, REMARKS
FROM SYSIBM.SYSTABLES
WHERE NAME IN ('BLAH', 'BLEH')
    AND TYPE IN ('T', 'V')
WITH UR;

/* Looking for Views that SELECT from something else */
SELECT NAME, CREATOR, TYPE, STATEMENT
FROM SYSIBM.SYSVIEWS
WHERE NAME IN ('BLAH', 'BLEH', 'BLEK')
WITH UR;


/* Looking for Columns */
SELECT NAME, TBNAME, TBCREATOR, REMARKS, COLTYPE, LENGTH, NULLS
FROM SYSIBM.SYSCOLUMNS
WHERE (
    NAME IN 'BLAH'
    OR NAME IN 'BLEH'
    OR NAME IN 'BLEK'
)
WITH UR;

/* Look for who ingested */
SELECT *
FROM COEDL_INGESTION.TIMES_V
WHERE BIGSQLSCHEMA = 'SCHEMA'
ORDER BY UPDATED [ASC|DESC]
WITH UR;

/* get row count of table */
SELECT COUNT(*) FROM SCHEMA.TABLE
/* Excel Formula for writing SQL to get row counts for list of tables in Excel 
="SELECT '"&B3&"' TABLE_NAME, COUNT(*) RECORDS FROM WSDIW."&B3&" UNION"
*/

/* get row counts of all tables */
-- Note STATS_TIME might be old, so CARD != COUNT(*)
SELECT TABSCHEMA, TABNAME, TRIM(TABSCHEMA) CONCAT '.' CONCAT TRIM(TABNAME) AS FULL_TABLE_NAME,
    CARD AS ROWS,
    STATS_TIME
FROM SYSCAT.TABLES
ORDER BY CARD DESC 

/* to get table organization (row vs column) from DB2 */
SELECT TABSCHEMA, TABNAME, TYPE, TABLEORG 
FROM SYSCAT.TABLES t 
WHERE TABSCHEMA IN ('WSDIW_A', 'WSDIW_B', 'ECOSYSTEMS_IZ')


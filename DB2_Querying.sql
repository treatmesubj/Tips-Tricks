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

/* Select all Schemas from Host DB2 */
SELECT * FROM SYSCAT.SCHEMATA;

/* Select all Tables in Schema */
SELECT * FROM SYSIBM.SYSTABLES
WHERE CREATOR = '<schema>';

/* Select all Views in Schema */
SELECT * FROM SYSIBM.SYSVIEWS
WHERE CREATOR = '<schema>';

/* Select all Columns in View or Table */
SELECT * FROM SCHEMA.VIEW_NAME WHERE 1 = 0;
--or
SELECT * FROM SYSIBM.SYSCOLUMNS
WHERE TBNAME = '<table>'
	AND TBCREATOR = '<schema>';

/* Select all Records Where Column Like <pattern> */
SELECT * FROM SCHEMA.TABLE
WHERE (
    COLUMN LIKE 'BLAH%'
    OR COLUMN LIKE 'BLEH%'
    OR COLUMN LIKE 'BLEK%'
    OR COLUMN LIKE 'DUH%'
)
WITH UR;

/* Count number of Records in Query*/
SELECT COUNT(*) AS ROW_COUNT
FROM SCHEMA.TABLE;

/* limit results to 10 rows */
SELECT * FROM SCHMEMA.TABLE
FETCH FIRST 10 ROWS ONLY
WITH UR;

/* Sort Results */
SELECT *
FROM SCHEMA.TABLE
ORDER BY COLUMN [ASC | DESC] --default ascending
WITH UR;
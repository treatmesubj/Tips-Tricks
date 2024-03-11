/* Meaningless Query */
WITH BLAH AS (
    SELECT *
    FROM (
        VALUES ('Hello world')
    ) t1 (col1)
    WHERE 1 = 1
)
SELECT *
FROM BLAH
LIMIT 1 OFFSET 0

/* ensure 2 strings are equal; string compare */
SELECT instr(',' || replace('     blah ', ' ', '') || ',', ',' || replace('  blah    ', ' ', '') || ',')
FROM BLAH

/* Storage Size of Tables in Schemas */
SELECT TABNAME,
    TABSCHEMA,
    SUM(DATA_OBJECT_P_SIZE) + SUM(INDEX_OBJECT_P_SIZE) + SUM(LONG_OBJECT_P_SIZE) + SUM(LOB_OBJECT_P_SIZE) + SUM(XML_OBJECT_P_SIZE) SIZE_KB 
FROM SYSIBMADM.ADMINTABINFO
WHERE TABSCHEMA IN ('FNP_A', 'SMS01_A')
GROUP BY TABNAME,
    TABSCHEMA

/* Delete Duplicates */
DELETE FROM
    (SELECT ROWNUMBER() OVER (PARTITION BY COL1, COL2, COL3) AS RN
     FROM SCHEMA.TABLE) AS A
WHERE RN > 1;

/* Looking for Schemas */
SELECT *
FROM SYSCAT.SCHEMATA --SYSIBM.SYSSCHEMAS
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

SELECT CREATOR, NAME, TYPE, REMARKS
FROM SYSIBM.SYSTABLES
WHERE NAME LIKE 'FACT_HEAD_COUNT_MONTHLY_STATIC%'
    AND TYPE IN ('T', 'V', 'A')
ORDER BY CREATOR, NAME
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

/* Get counts of column values for column */
SELECT COLUMN_NAME, COUNT(*)
FROM SCHEMA_NAME.TABLE_NAME
GROUP BY COLUMN_NAME;

/* Cases */
SELECT 
    COLUMN_A, 
    COLUMN_B,
    CASE
       WHEN ...
       THEN ...
       ELSE ...
    END AS COLUMN_C,
    COLUMN_D
FROM SCHEMA.TABLE


/* Learn Alias Table Targets */
SELECT  TYPE,
        TABSCHEMA, 
        TABNAME, 
        BASE_TABSCHEMA, 
        BASE_TABNAME 
FROM SYSCAT.TABLES 
WHERE TABNAME LIKE '%WW_LOAD_SMS%'
WITH UR

/* Learn about schema access */
SELECT * FROM syscat.SCHEMAAUTH WHERE schemaname='EAL_EAL' WITH ur;

/* --------------------------------------------
Create empty table in same structure as other
 -------------------------------------------- */
DROP TABLE SCHEMA.TABLE_B;

CREATE TABLE SCHEMA.TABLE_B AS (
    SELECT *
    FROM SCHEMA.TABLE_A ds
    WHERE 1=0
)
WITH DATA;

INSERT INTO SCHEMA.TABLE_B
SELECT * FROM SCHEMA_TABLE_A;

GRANT SELECT ON SCHEMA.TABLE_B TO ROLE READER;

/* Create View */
CREATE VIEW SCHEMA.VIEW AS (
    SELECT *
    FROM SCHEMA.TABLE
);

/* INSERT slightly edited data from old table into new table */
INSERT INTO ACCESS_B.DATA_SOURCE
SELECT TRIM(BOTH ' ' FROM EMAIL) EMAIL, DATA_SOURCE_ACRONYM
FROM ACCESS_A.DATA_SOURCE

/* Delete data */
DELETE FROM SCHEMA.TABLE
WHERE 1=1 -- all
OR COLUMN = 'BLAH'

/* BigSQL Logs */
/* SQL Error [58040]: DB2 SQL Error: SQLCODE=-5105, SQLSTATE=58040, SQLERRMC=BigSQL IO;UNKNOWN;[BSL-5-282fd4bb4];optional group COUNTRYLIST (LI, DRIVER=4.26.14 */
SELECT CAST(LINE AS VARCHAR(300))
FROM TABLE(SYSHADOOP.LOG_ENTRY('BSL-5-282fd4bb4'))
WITH UR;

/* Grant SELECT privilege */
GRANT SELECT ON SCHMEMA.TABLE TO USER "USER_NAME";
GRANT SELECT ON SCHMEMA.TABLE TO ROLE READER;

/* Looking for duplicates from join */
WITH joined AS (
    SELECT
        a.COL1,
        b.COL1,
        b.COL2,
        b.COL3,
        ROWNUMBER() OVER (PARTITION BY a.COL1) AS RN
    FROM SCHEMA.TABLE_A a
    LEFT JOIN SCHEMA.TABLE_B b
        ON a.COL1 = b.COL2
)
SELECT *
FROM joined
WHERE RN > 1
ORDER BY RN DESC

/* Delete duplicate rows from table */
DELETE FROM
    (SELECT ROWNUMBER() OVER (PARTITION BY EMAIL, META_GEO, META_MKT) AS RN
     FROM ACCESS_A.META_GEO_MKT_EMAIL_ENTLMNTS) AS A
WHERE RN > 1;


/* Custom Order By Field */
SELECT WEEKDAY(MISCHIEF_DATE) WEEKDAY, MISCHIEF_DATE, AUTHOR, TITLE
FROM MISCHIEF
ORDER BY WEEKDAY, FIELD(AUTHOR, 'Huey', 'Dewey', 'Louie'), MISCHIEF_DATE, TITLE;

/* More complicated string parsing logic */
SELECT *
FROM users
WHERE attribute LIKE BINARY CONCAT('_%\%', first_name, '\_', second_name, '\%%')
-- one or more chars before first_name, then _, then 2nd name, then %, then anything
ORDER BY ATTRIBUTE;

/* HAVING is WHERE for GROUP BY */
select distinct director
from moviesInfo 
where year > 2000
group by director
having sum(oscars) > 2  
order by director;

/* GROUP_CONCAT */
WITH my_countries AS (
    SELECT DISTINCT COUNTRY
    FROM DIARY
    ORDER BY COUNTRY
)
SELECT GROUP_CONCAT(COUNTRY SEPARATOR ';') AS COUNTRIES
FROM my_countries;

WITH stringys AS (
    SELECT
    DISTINCT CONCAT(FIRST_NAME, ' ', SURNAME, ' #', PLAYER_NUMBER) STR
    FROM SOCCER_TEAM
    ORDER BY PLAYER_NUMBER
)
SELECT GROUP_CONCAT(STR SEPARATOR '; ') AS PLAYERS
FROM stringys;

/* Proper TRIMMING */
SELECT COUNT(*) NUMBER_OF_NULLS
FROM DEPARTMENTS
WHERE TRIM(DESCRIPTION) IN ('NULL', 'nil', '-')
OR DESCRIPTION IS NULL;

/* Multiply characters of strings in column */
/*
      So the 'trick' here is to MULTPLY by the ADDITION of logs
      We have a SUM function but not a MULT fuction
      So first find the length then take log of that for each row
      and use sum to add up the logs.  Now exp to reverse it so
      that we have just x*y*z*.....  But it will be a decimal so round it.
*/
SELECT ROUND(
               EXP(
                     SUM(
                           LOG(
                                LENGTH(characters)
                               )
                         )
                  )
             ) 
AS combinations
FROM discs;

/* If a table for some reason uses a 'hobbies' set column */
SELECT name
FROM people_hobbies
WHERE hobbies & FIND_IN_SET('reading', hobbies)
AND hobbies & FIND_IN_SET('sports', hobbies)
ORDER BY NAME;

/* You can sum with conditions */
WITH SUMMED AS (
    SELECT
        SUM(IF(first_team_score > second_team_score, 1, 0)) team1_wins,
        SUM(IF(second_team_score > first_team_score, 1, 0)) team2_wins,
        SUM(first_team_score) team1_goals,
        SUM(second_team_score) team2_goals,
        SUM(IF(match_host= 2, first_team_score, 0)) team1_away_goals,
        SUM(IF(match_host= 1, second_team_score, 0)) team2_away_goals
    FROM scores
)
SELECT 
    CASE
        WHEN team1_wins > team2_wins THEN 1
        WHEN team2_wins > team1_wins THEN 2
        WHEN team1_goals > team2_goals THEN 1
        WHEN team2_goals > team1_goals THEN 2
        WHEN team1_away_goals > team2_away_goals THEN 1
        WHEN team2_away_goals > team1_away_goals THEN 2
        ELSE 0
    END AS WINNER
FROM SUMMED;

/* Variables and DateDiff */
SET @MAX_DATE = (SELECT MAX(EVENT_DATE) FROM EVENTS);
SELECT name, event_date
FROM EVENTS
WHERE DATEDIFF(@MAX_DATE, event_date) > 0
    AND DATEDIFF(@MAX_DATE, event_date) <= 7
ORDER BY EVENT_DATE DESC;

/* Variables */
SET @MAX_SALARY = (SELECT MAX(SALARY) FROM EMPLOYEES);
SET @MIN_SALARY = (SELECT MIN(SALARY) FROM EMPLOYEES);
SELECT @MAX_SALARY - @MIN_SALARY SALARY_DIFF;

/* add foreign key */
ALTER TABLE TABLE_A ADD FOREIGN KEY (COLUMN_1)
REFERENCES TABLE_B(COLUMN_1)
--ON DELETE CASCADE; -- delete from all tables
ON DELETE SET NULL; -- just make it NULL in referenced tables

/* update string column text */
UPDATE TABLE_A
SET COLUMN_A = CONCAT('prefix - ', COLUMN_A),
    COLUMN_B = CONCAT('prefix - ', COLUMN_B)

/* to table, add columns with default values */
ALTER TABLE TABLE_A
ADD COLUMN COLUMN_A VARCHAR(100) DEFAULT 'placeholder',
ADD COLUMN COLUMN_B TINYINT(1) DEFAULT 1;

/* which IDs are missing from TABLE_B? */
SELECT ID
FROM TABLE_A
WHERE EXISTS (
    SELECT *
    FROM TABLE_B
    WHERE TABLE_A.ID = TABLE_B.ID
);

SELECT ID
FROM TABLE_A a
LEFT JOIN TABLE_B b
    ON a.ID = b.ID
WHERE b.ID IS NULL;


/* painful ordering of tables, then joining tables & preserving their orders */
WITH pr5 AS (
        SELECT name, 1 filter
        FROM pr_department
        ORDER BY date_joined desc
        LIMIT 5
),
it5 AS (
    SELECT name, 2 filter
    FROM it_department
    ORDER BY date_joined desc
    LIMIT 5
),
sales5 AS (
    SELECT name, 3 filter
    FROM sales_department
    ORDER BY date_joined desc
    LIMIT 5
),
joined_ordered AS (
    SELECT name, filter from pr5
    UNION ALL
    SELECT name, filter from it5
    UNION ALL
    SELECT name, filter from sales5
    order by filter, name
)
SELECT NAME
FROM joined_ordered;

/* more painful ordering of crap */
WITH joined_crap AS (
    SELECT
        ID,
        'name' COLUMN_NAME,
        NAME VALUE,
        1 filter
    FROM WORKERS_INFO
    WHERE NAME IS NOT NULL
    UNION ALL
    SELECT
        ID,
        'date_of_birth' COLUMN_NAME,
        DATE_OF_BIRTH VALUE,
        2 filter
    FROM WORKERS_INFO
    WHERE DATE_OF_BIRTH IS NOT NULL
    UNION ALL
    SELECT
        ID,
        'salary' COLUMN_NAME,
        SALARY VALUE,
        3 filter
    FROM WORKERS_INFO
    WHERE SALARY IS NOT NULL
)
SELECT ID, COLUMN_NAME, VALUE
FROM joined_crap
ORDER BY ID, filter;

/* Easier ordering of crap */
SELECT COL_A, COL_B
FROM SCHEMA.TABLE
ORDER BY COL_A, FIELD(COL_B, 'value1', 'value2', 'value3')


/*
fetch last each anonymous-id's event and its first signed-up-user event
using  row_number partion & order
*/
WITH LAST_NULLS AS (
    SELECT anonymous_id, event_name, received_at,
        ROW_NUMBER() OVER (
            PARTITION BY anonymous_id
            ORDER BY RECEIVED_AT DESC
        ) LATEST_1
    from tracks
    where user_id is NULL
),
FIRST_NOTNULLS AS (
    SELECT anonymous_id, event_name, received_at,
    ROW_NUMBER() OVER (
            PARTITION BY anonymous_id
            ORDER BY RECEIVED_AT ASC
        ) FIRST_1
    from tracks
    where user_id is NOT NULL
)
SELECT
    LAST_NULLS.ANONYMOUS_ID anonym_id,
    LAST_NULLS.EVENT_NAME last_null,
    FIRST_NOTNULLS.EVENT_NAME first_notnull
FROM LAST_NULLS
LEFT JOIN FIRST_NOTNULLS
    ON LAST_NULLS.ANONYMOUS_ID = FIRST_NOTNULLS.ANONYMOUS_ID
WHERE LAST_NULLS.LATEST_1 = 1
AND (FIRST_NOTNULLS.FIRST_1 = 1
    OR FIRST_NOTNULLS.FIRST_1 IS NULL);


/* transpose column headers and values */
SELECT
    ID,
    'name' COLUMN_NAME,
    NAME VALUE
FROM WORKERS_INFO
WHERE NAME IS NOT NULL
UNION ALL
SELECT
    ID,
    'date_of_birth' COLUMN_NAME,
    DATE_OF_BIRTH VALUE
FROM WORKERS_INFO
WHERE DATE_OF_BIRTH IS NOT NULL
UNION ALL
SELECT
    ID,
    'salary' COLUMN_NAME,
    SALARY VALUE
FROM WORKERS_INFO
WHERE SALARY IS NOT NULL


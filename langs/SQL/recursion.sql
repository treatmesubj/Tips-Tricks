/* recursively print 1 - 10 */
WITH numbers (n) AS (
  SELECT 1 AS n
  FROM SYSIBM.SYSDUMMY1     -- anchor/non-recursive base query
  UNION ALL
  SELECT n + 1              -- recursive query
  FROM numbers
  WHERE n < 10              -- termination/break/exit
)
SELECT *
FROM numbers;               -- invocation


/* recursively print 5! (factorial) */
WITH numbers (n, fact) AS (
  SELECT 1 AS n, 1 AS fact
  FROM SYSIBM.SYSDUMMY1           -- anchor/non-recursive base query
  UNION ALL
  SELECT n + 1, (n + 1) * fact    -- recursive query
  FROM numbers
  WHERE n < 5                     -- termination/break/exit
)
SELECT *
FROM numbers;                     -- invocation


/* show me all employees underneath a manager */
WITH emp_hierarchy (CNUM, BLUEPAGES_NAME, FUNCTIONAL_MANAGER_CNUM, DEPTH) AS (
  SELECT
    CNUM,
    BLUEPAGES_NAME,
    FUNCTIONAL_MANAGER_CNUM,
    1 AS DEPTH                          -- (lowest DEPTH of management, Lyndal)
  FROM WF360_HR.DIM_EMPLOYEE_PSN_PBD
  WHERE CNUM ='5A7795897'               -- anchor/non-recursive base query
  UNION ALL
  SELECT
    E.CNUM,
    E.BLUEPAGES_NAME,
    E.FUNCTIONAL_MANAGER_CNUM,
    H.DEPTH + 1 AS DEPTH                -- recursive query
  FROM emp_hierarchy H, WF360_HR.DIM_EMPLOYEE_PSN_PBD E
  WHERE H.CNUM = E.FUNCTIONAL_MANAGER_CNUM                    -- termination/break/exit
)
SELECT *
FROM emp_hierarchy;                     -- invocation


/* show me all regular employees underneath a manager as of 12/31/2025 */
WITH emp_hierarchy (
  CNUM,
  BLUEPAGES_NAME,
  FUNCTIONAL_MANAGER_CNUM,
  EFFECTIVE_DATE,
  EXPIRATION_DATE,
  DEPTH
) AS (
  SELECT
    CNUM,
    BLUEPAGES_NAME,
    FUNCTIONAL_MANAGER_CNUM,
    EFFECTIVE_DATE,
    EXPIRATION_DATE,
    1 AS DEPTH  -- (lowest DEPTH of management, Lyndal)
  FROM WF360_HR.DIM_EMPLOYEE_HISTORY_PSN_PBD
  WHERE (CNUM = '5A7795897' OR LOWER(INTERNET_EMAIL) = 'lyndal@us.ibm.com')  -- anchor/non-recursive base query
    -- AND CURRENT_INDICATOR = 1
    AND EFFECTIVE_DATE <= '12-31-2025'
    AND EXPIRATION_DATE > '12-31-2025'
    AND EMPLOYMENT_STATUS_CODE = 'A'
    AND BP_EMPLOYEE_TYPE = 'P'  -- IBM Regular
  UNION ALL
  SELECT
    E.CNUM,
    E.BLUEPAGES_NAME,
    E.FUNCTIONAL_MANAGER_CNUM,
    E.EFFECTIVE_DATE,
    E.EXPIRATION_DATE,
    H.DEPTH + 1 AS DEPTH  -- recursive query
  FROM emp_hierarchy H, WF360_HR.DIM_EMPLOYEE_HISTORY_PSN_PBD E
  WHERE H.CNUM = E.FUNCTIONAL_MANAGER_CNUM  -- termination/break/exit
    -- AND E.CURRENT_INDICATOR = 1
    AND E.EFFECTIVE_DATE <= '12-31-2025'
    AND E.EXPIRATION_DATE > '12-31-2025'
    AND E.EMPLOYMENT_STATUS_CODE = 'A'
    AND E.BP_EMPLOYEE_TYPE = 'P'  -- IBM Regular
)
SELECT *
FROM emp_hierarchy;  -- invocation


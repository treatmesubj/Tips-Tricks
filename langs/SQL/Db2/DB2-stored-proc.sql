/* stored procedure */
CREATE OR REPLACE PROCEDURE SCHEMA.SYNC_COLORS (
    IN ALIAS_SCHEMA_ARG VARCHAR(100),
    IN ALIAS_NAME_ARG VARCHAR(200)
)
LANGUAGE SQL
P1:
BEGIN

    DECLARE TAB_BASE_NAME VARCHAR(200);
    DECLARE SCHEMA_NAME VARCHAR(100);
    DECLARE ALIAS_NAME VARCHAR(200);
    DECLARE ACTIVE_ALIAS_COLOR VARCHAR(100);
    DECLARE ACTIVE_ALIAS VARCHAR(200);
    DECLARE STMT VARCHAR(3000);
    DECLARE QUERY VARCHAR(20000);

    DECLARE ALIAS_TAB VARCHAR(1000);
    DECLARE ACTIVE_COLOR_TAB VARCHAR(1000);
    DECLARE INACTIVE_COLOR_TAB VARCHAR(1000);
    DECLARE ACTIVE_COLOR_COUNT_SQL VARCHAR(20000);
    DECLARE INACTIVE_COLOR_COUNT_SQL VARCHAR(20000);
    DECLARE ACTIVE_COLOR_COUNT INTEGER;
    DECLARE INACTIVE_COLOR_COUNT INTEGER;
    DECLARE ACTIVE_COLOR_COUNT_STATEMENT STATEMENT;
    DECLARE INACTIVE_COLOR_COUNT_STATEMENT STATEMENT;

    DECLARE CURSOR_GET_DATA CURSOR FOR SELECT_QUERY;

    SET QUERY = 'SELECT BASE_TABNAME, TABSCHEMA, TABNAME FROM syscat.tables WHERE tabschema = ? AND tabname = ?';

    /* prepend 'DEV_' to schema-arg in Staging */
    IF SUBSTR(CURRENT SCHEMA, 1, 4) = 'DEV_'
    THEN SET ALIAS_SCHEMA_ARG = 'DEV_' || ALIAS_SCHEMA_ARG;
    END IF;

    PREPARE SELECT_QUERY FROM QUERY;
    OPEN CURSOR_GET_DATA USING ALIAS_SCHEMA_ARG, ALIAS_NAME_ARG;
    FETCH FROM CURSOR_GET_DATA INTO TAB_BASE_NAME, SCHEMA_NAME, ALIAS_NAME;
    CLOSE CURSOR_GET_DATA;

    SET ALIAS_TAB = SCHEMA_NAME || '.' || ALIAS_NAME;
    SET ACTIVE_ALIAS_COLOR = SUBSTR(TAB_BASE_NAME, LOCATE_IN_STRING(TAB_BASE_NAME, '_', -1) + 1);

    IF ACTIVE_ALIAS_COLOR = 'GREEN' THEN
        SET ACTIVE_COLOR_TAB = ALIAS_TAB || '_GREEN';
        SET INACTIVE_COLOR_TAB = ALIAS_TAB || '_BLUE';

        SET STMT = 'TRUNCATE ' || INACTIVE_COLOR_TAB;
        PREPARE COMMAND FROM STMT;
        EXECUTE COMMAND;

        SET STMT = 'INSERT INTO ' || INACTIVE_COLOR_TAB || ' SELECT * FROM ' || ALIAS_TAB;
        PREPARE COMMAND FROM STMT;
        EXECUTE COMMAND;

    ELSEIF ACTIVE_ALIAS_COLOR = 'BLUE' THEN
        SET ACTIVE_COLOR_TAB = ALIAS_TAB || '_BLUE';
        SET INACTIVE_COLOR_TAB = ALIAS_TAB || '_GREEN';

        SET STMT = 'TRUNCATE ' || INACTIVE_COLOR_TAB;
        PREPARE COMMAND FROM STMT;
        EXECUTE COMMAND;

        SET STMT = 'INSERT INTO ' || INACTIVE_COLOR_TAB || ' SELECT * FROM ' || ALIAS_TAB;
        PREPARE COMMAND FROM STMT;
        EXECUTE COMMAND;

    ELSE
        CALL RAISE_APPLICATION_ERROR (-20010, 'TABLE ' || ALIAS_NAME || ' DOES NOT HAVE THE PROPER ALIAS (BLUE OR GREEN)');

    END IF;

    /* validate row counts */
    SET ACTIVE_COLOR_COUNT_SQL = 'SET (?) = (' || 'SELECT COUNT(*) AS COUNT FROM ' || ACTIVE_COLOR_TAB || ') ';
    SET INACTIVE_COLOR_COUNT_SQL = 'SET (?) = (' || 'SELECT COUNT(*) AS COUNT FROM ' || INACTIVE_COLOR_TAB || ') ';

    PREPARE ACTIVE_COLOR_COUNT_STATEMENT FROM ACTIVE_COLOR_COUNT_SQL;
    PREPARE INACTIVE_COLOR_COUNT_STATEMENT FROM INACTIVE_COLOR_COUNT_SQL;

    EXECUTE ACTIVE_COLOR_COUNT_STATEMENT INTO ACTIVE_COLOR_COUNT;
    EXECUTE INACTIVE_COLOR_COUNT_STATEMENT INTO INACTIVE_COLOR_COUNT;

    IF ACTIVE_COLOR_COUNT = INACTIVE_COLOR_COUNT
    THEN COMMIT;
    ELSE
        SIGNAL SQLSTATE '99999' SET MESSAGE_TEXT = 'COUNT IS DIFFERENT';
    END IF;

END P1


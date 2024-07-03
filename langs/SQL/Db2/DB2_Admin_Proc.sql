--https://www.ibm.com/docs/en/db2oc?topic=procedure-admin-cmd-run-administrative-commands

--SELECT *
--FROM SYSIBMADM.DBMCFG
--WHERE NAME = 'diaglevel';

CALL SYSPROC.ADMIN_CMD('update dbm cfg using DIAGLEVEL 4');

-- https://stackoverflow.com/questions/55495082/list-history-of-sql-statements-in-db2-warehouse-on-cloud
-- https://www.ibm.com/docs/en/db2woc?topic=SS6NHC/com.ibm.swg.im.dashdb.security.doc/doc/audit_policy_guidelines.htm#audit_policy_guidelines__title__3

create audit policy exec_policy categories execute status both error type normal;
audit database using policy exec_policy;
select * from SYSCAT.AUDITUSE; -- show audit policies

-- *user executes statement*

call audit.update(); -- updates audit.execute table from logs


select * from audit.execute

-- remove policy
audit database remove policy;
select * from SYSCAT.AUDITUSE; -- show audit policies

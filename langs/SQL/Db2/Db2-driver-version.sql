-- Db2 version & corresponding driver version
-- https://www.ibm.com/support/pages/db2-jdbc-driver-versions-and-downloads

-- java -cp ./db2jcc4.jar com.ibm.db2.jcc.DB2Jcc -version
-- # IBM Data Server Driver for JDBC and SQLJ 4.25.13

-- Db2 LUW
SELECT service_level, fixpack_num
FROM TABLE (sysproc.env_get_inst_info()) as INSTANCEINFO
-- FROM SYSIBMADM.ENV_INST_INFO

-- Db2 z/OS
SELECT GETVARIABLE('SYSIBM.VERSION') FROM SYSIBM.SYSDUMMY1

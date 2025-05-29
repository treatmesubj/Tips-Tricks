SELECT service_level, fixpack_num
FROM TABLE (sysproc.env_get_inst_info()) as INSTANCEINFO
-- SERVICE_LEVEL	FIXPACK_NUM
-- DB2 v11.5.9.0	0

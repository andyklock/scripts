REM $Header: v1.0 flush_cursor.sql 2016/08/25 andy.klock $
select 'exec DBMS_SHARED_POOL.PURGE ('''||ADDRESS||', ' || HASH_VALUE||''', ''C''); -- run from instance'||inst_id 
from GV$SQLAREA 
where SQL_ID = '&sql_id' order by inst_id;

REM $Header: v1.0 baselines.sql 2016/05/04 andy.klock $
REM Purpose: Shows simple information about available baselines, mostly if it's accepted, fixed, and enabled
REM Note, the last executed is the time it was last parsed
col created for a30
col last_executed for a30
col sql_handle for a30
col plan_name for a30
col SIGNATURE for 99999999999999999999999999
select sql_handle,signature, plan_name, created, last_executed,accepted,fixed,enabled from dba_sql_plan_baselines order by created,sql_handle, created;
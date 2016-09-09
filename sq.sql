REM $Header: v1.0 sq.sql 2016/05/23 andy.klock $
REM Show simple cursor information, includes baselines and sql profiles
select inst_id,child_number,executions,plan_hash_value,sql_plan_baseline,sql_profile, last_active_time,elapsed_time/decode(executions,0,1,executions)/1000000 avg_elapsed	 from gv$sql where sql_id = '&1' order by last_active_time;
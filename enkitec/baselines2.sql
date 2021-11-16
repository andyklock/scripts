set lines 200
col sql_text for a50 trunc
col sql_id for a13
col plan_hash_value for a15
col sql_handle for a20
col last_executed for a28
col enabled for a7
col last_executed for a16
break on sql_id on sql_text
select baseline_info(plan_name, 'sql_id') sql_id, 
       sql_text,
       baseline_info(plan_name, 'plan_hash_value') plan_hash_value, 
       sql_handle,
       plan_name,
       enabled, 
       accepted, 
       fixed, 
       to_char(last_executed,'dd-mon-yy HH24:MI') last_executed
from dba_sql_plan_baselines 
where sql_text like nvl('%'||'&sql_text'||'%',sql_text)
and sql_handle like nvl('&name',sql_handle)
and upper(plan_name) like upper(nvl('&plan_name',plan_name))
order by 1,fixed
/

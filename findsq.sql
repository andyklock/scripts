col sub_text for a55

select sql_id,plan_hash_value,length(sql_fulltext),substr(sql_text,0,50) sub_text, executions,elapsed_time/decode(executions,0,1,executions)/1000000 avg_elapsed from gv$sql where lower(sql_text) like lower('%&1%') and sql_text not like '%v$sql%' order by executions;


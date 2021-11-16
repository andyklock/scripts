set verify off
set pagesize 999
col username format a13
col prog format a22
col sql_text format a41
col sid format 999
col etime for 999,999.99
col rows_ for 999,999,999
col avg_etime for 999,999.99
col child_number format 99999 heading CHILD
col ocategory format a10

select address, hash_value, child_number, executions execs, elapsed_time/1000000 etime, 
elapsed_time/1000000/decode(nvl(executions,1),0,1,executions) avg_etime, rows_processed rows_,
first_load_time, plan_hash_value, sql_text
from v$sql
where upper(sql_text) like upper(nvl('&sql_text',sql_text))
and sql_text not like '%from v$sql where sql_text like nvl(%'
and hash_value like nvl('&hash_value',hash_value)
and executions > 0
/


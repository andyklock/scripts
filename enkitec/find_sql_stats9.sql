set verify off
set lines 155
set pagesize 999
col username format a13
col prog format a22
col sql_text format a41
col sid format 999
col child_number format 99999 heading CHILD
col ocategory format a10
col execs format 9,999,999
col execs_per_sec format 999,999.99
col etime format 9,999,999.99
col avg_etime format 9,999,999.99
col cpu format 9,999,999
col avg_cpu  format 9,999,999.99
col pio format 9,999,999
col avg_pio format 9,999,999.99
col lio format 9,999,999
col avg_lio format 9,999,999.99
col avg_fetches format 9,999,999.99
col avg_rows format 9,999,999

select hash_value, child_number,
executions execs,
executions/((sysdate-to_date(first_load_time,'YYYY-MM-DD/HH24:MI:SS'))*(24*60*60)) execs_per_sec,
-- elapsed_time/1000000 etime,
(elapsed_time/1000000)/decode(nvl(executions,0),0,1,executions) avg_etime,
-- cpu_time/1000000 cpu,
(cpu_time/1000000)/decode(nvl(executions,0),0,1,executions) avg_cpu,
-- disk_reads pio,
disk_reads/decode(nvl(executions,0),0,1,executions) avg_pio,
-- buffer_gets lio,
buffer_gets/decode(nvl(executions,0),0,1,executions) avg_lio,
fetches/decode(nvl(executions,0),0,1,executions) avg_fetches,
rows_processed/decode(nvl(executions,0),0,1,executions) avg_rows,
sql_text
from v$sql s
where sql_text like nvl('&sql_text',sql_text)
and sql_text not like '%from v$sql where sql_text like nvl(%'
and address like nvl('&address',address)
and hash_value like nvl('&hash_value',hash_value)
/

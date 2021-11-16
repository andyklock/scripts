set verify off
set pagesize 999
col username format a13
col prog format a22
col sql_text format a41
col sid format 999
col child_number format 99999 heading CHILD
col ocategory format a10
col avg_etime format 9,999,999.99
col avg_etime format 9,999,999.99
col etime format 9,999,999.99

select * from (
select hash_value, sql_id, child_number, executions execs, rows_processed "Rows", elapsed_time/1000000 etime,
(elapsed_time/1000000)/decode(nvl(executions,0),0,1,executions) avg_etime,
sql_text
from v$sql s
where sql_text like nvl('&sql_text',sql_text)
and sql_text not like '%from v$sql where sql_text like nvl(%'
and address like nvl('&address',address)
and sql_id like nvl('&sql_id',sql_id)
order by last_active_time)
where rownum < 5
/


set long 32000
set verify off
set pagesize 999
col username format a13
col prog format a22
col sql_text format a41
col sid format 999
col child_number format 99999 heading CHILD
col ocategory format a10
col avg_etime format 9,999,999.99
col etime format 9,999,999.99

select sql_id, 
sql_text
from dba_hist_sqltext
where sql_text like nvl('&sql_text',sql_text)
and sql_text not like '%from dba_hist_sqltext where sql_text like nvl(%'
and sql_id like nvl('&sql_id',sql_id)
/

set verify off
set pagesize 999
col username format a13
col prog format a22
col sql_text format a41
col sid format 999
col child_number format 99999 heading CHILD
col ocategory format a10

select address, hash_value, child_number, executions execs, parsing_user_id, outline_sid osid, outline_category ocategory,
first_load_time, sql_text
from v$sql
where sql_text like nvl('&sql_text',sql_text)
and sql_text not like '%from v$sql where sql_text like nvl(%'
and hash_value like nvl(hash_value,'&hash_value')
/


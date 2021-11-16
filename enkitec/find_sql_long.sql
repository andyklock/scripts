set lines 155
col sql_text for a70
select sql_text
from v$sqltext
where sql_text like nvl('&sql_text','%')
and sql_id like nvl('&sql_id',sql_id)
order by piece
/


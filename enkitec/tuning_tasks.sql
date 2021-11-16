SELECT owner, task_name, status, to_char(execution_start,'DD-MON-YY HH24:MI')
FROM dba_advisor_log 
WHERE owner like nvl('&owner',owner)
and task_name like nvl('&task_name',task_name)
and status like nvl ('&status',status)
order by execution_start
/


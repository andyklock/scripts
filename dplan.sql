-- Purpose:     show plan for statement in V$SQL (uses dbms_xplan)
set verify off
set pages 9999
select * from table(dbms_xplan.display_cursor('&sql_id','&child_no','ADVANCED +ALLSTATS LAST +MEMSTATS LAST')) 
/

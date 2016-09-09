-- Purpose:     show plan for statement in AWR history
-- Source:      http://blog.enkitec.com/enkitec_scripts/dplan_awr.sql
SELECT * FROM table(dbms_xplan.display_awr(nvl('&sql_id','a96b61z6vp3un'),nvl('&plan_hash_value',null),null,'ADVANCED +ALLSTATS LAST +MEMSTATS LAST'))
/
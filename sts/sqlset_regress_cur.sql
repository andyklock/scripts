REM $Header: v1.0 sqlset_regress_cur.sql 2016/07/24 andy.klock $
select v12c.sql_id, 
       v12c.v12c_phv, 
       v12c.executions, 
       v12c.avg_etime, 
       v11g.v11g_phv, 
       v11g.executions, 
       v11g.avg_etime, 
       decode(v12c.v12c_phv,v11g.v11g_phv,null,'*')diff_phv,
       v11g.avg_etime-v12c.avg_etime diff_etime,
       case when v12c.avg_etime > v11g.avg_etime THEN 'Regressed'
         else 'Improved' end performance
from 
(select sql_id,plan_hash_value v12c_phv,sum(executions) executions, (sum(elapsed_time))/(decode(sum(executions),0,1,sum(executions)))/1000000 avg_etime
from gv$sql where 
plan_hash_value <> 0 
group by sql_id,plan_hash_value) v12c,
(select sql_id,plan_hash_value v11g_phv,sum(executions) executions, (sum(elapsed_time))/(decode(sum(executions),0,1,sum(executions)))/1000000 avg_etime
from dba_sqlset_statements where sqlset_owner = '&SQLSET_OWNER' and plan_hash_value <> 0 
group by sql_id,plan_hash_value) v11g
where v11g.sql_id = v12c.sql_id 
order by performance desc,diff_etime asc;
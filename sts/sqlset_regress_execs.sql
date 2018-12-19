REM $Header: v1.0 sqlset_regress_cur.sql 2016/07/24 andy.klock $

define regressed_threshold_seconds = -.01
define last_active_time = trunc(sysdate)
define l_executions = 25000
select curr.sql_id, 
       curr.curr_phv, 
       curr.executions, 
       curr.avg_etime, 
       STS.STS_phv, 
       STS.executions, 
       STS.avg_etime, 
       decode(curr.curr_phv,STS.STS_phv,null,'*')diff_phv,
       STS.avg_etime-curr.avg_etime diff_etime,
       case when curr.avg_etime > STS.avg_etime THEN 'Regressed'
         else 'Improved' end performance
from 
(select sql_id,plan_hash_value curr_phv,sum(executions) executions, (sum(elapsed_time))/(decode(sum(executions),0,1,sum(executions)))/1000000 avg_etime
from gv$sql where 
plan_hash_value <> 0 and last_active_time > &last_active_time 
group by sql_id,plan_hash_value having sum(executions) > &l_executions) curr,
(select sql_id,plan_hash_value STS_phv,sum(executions) executions, (sum(elapsed_time))/(decode(sum(executions),0,1,sum(executions)))/1000000 avg_etime
from dba_sqlset_statements where sqlset_owner = '&SQLSET_OWNER' and sqlset_name like '%&sqlset_name%' and plan_hash_value <> 0 
group by sql_id,plan_hash_value) STS
where STS.sql_id = curr.sql_id 
and curr.avg_etime > STS.avg_etime
and (STS.avg_etime-curr.avg_etime) < &regressed_threshold_seconds
and curr.curr_phv <> STS.STS_phv
order by performance desc,diff_etime asc;
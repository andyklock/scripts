REM $Header: v1.0 awr_plan_change_all.sql 2016/02/13 andy.klock $
REM originally taken from http://blog.enkitec.com/enkitec_scripts/awr_plan_change.sql
REM Added some additional columns to track where time is being spent
col execs for 999,999,999
col avg_etime for 999,999.999
col avg_lio for 999,999,999.9
col AVG_CPUTIME for 999,999.999
col AVG_IOTIME for 999,999.999
col AVG_CLUSTERTIME for 999,999.999
col begin_interval_time for a30
col node for 99999
break on plan_hash_value on startup_time skip 1
select ss.snap_id, ss.instance_number node, begin_interval_time, sql_id, plan_hash_value,
nvl(executions_delta,0) execs,
(elapsed_time_delta/decode(nvl(executions_delta,0),0,1,executions_delta))/1000000 avg_etime,
(CPU_TIME_DELTA/decode(nvl(executions_delta,0),0,1,executions_delta))/1000000 avg_cputime,
(IOWAIT_DELTA/decode(nvl(executions_delta,0),0,1,executions_delta))/1000000 avg_iotime,
(CLWAIT_DELTA/decode(nvl(executions_delta,0),0,1,executions_delta))/1000000 avg_clustertime,
(buffer_gets_delta/decode(nvl(buffer_gets_delta,0),0,1,executions_delta)) avg_lio,
(PLSEXEC_TIME_DELTA/decode(nvl(PLSEXEC_TIME_DELTA,0),0,1,executions_delta)) avg_plsql_time
--,sql_profile
from DBA_HIST_SQLSTAT S, DBA_HIST_SNAPSHOT SS
where sql_id = nvl('&sql_id','4dqs2k5tynk61')
and ss.snap_id = S.snap_id
and ss.instance_number = S.instance_number
and executions_delta > 0
and ss.begin_interval_time > trunc(sysdate)-(nvl(&1,1000))
order by 1, 2, 3;
clear breaks
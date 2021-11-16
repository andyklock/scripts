----------------------------------------------------------------------------------------
--
-- File name:   dbtime.sql
-- Purpose:     Find busiest time periods in AWR.
-
-- Author:      Kerry Osborne
--
-- Usage:       This scripts prompts for three values, all of which can be left blank.
--
--              instance_number: set to limit to a single instance in RAC environment, defaults to corrent instance
--
--              begin_snap_id: set it you want to limit to a specific range, defaults to 0
--
--              end_snap_id: set it you want to limit to a specific range, defaults to 99999999
--
--
---------------------------------------------------------------------------------------
set lines 155
col minutes for 999.9
col ratio for 9.999
col dbtime for 999,999.99
col begin_timestamp for a40
select begin_snap, end_snap, begin_timestamp, inst, DBtime, dbtime/(cpu_count*minutes) ratio, minutes
from (
select begin_snap, end_snap, timestamp begin_timestamp, inst, a/1000000/60 DBtime,cpu_count  , minutes
from
(
select
   ROUND
   (
      TO_NUMBER
         (
            TO_DATE(TO_CHAR(END_INTERVAL_TIME, 'DDMMYYYY:HH24:MI:SS'), 'DDMMYYYY:HH24:MI:SS')
            -
            TO_DATE(TO_CHAR(BEGIN_INTERVAL_TIME, 'DDMMYYYY:HH24:MI:SS'), 'DDMMYYYY:HH24:MI:SS')
         ) * 24 * 60
   ,3) minutes,
 e.snap_id end_snap,
 lag(e.snap_id) over (order by e.snap_id) begin_snap,
 lag(s.end_interval_time) over (order by e.snap_id) timestamp,
 s.instance_number inst,
 p.value cpu_count,
 nvl(e.value-lag(e.value) over (order by e.snap_id),0) a
from dba_hist_sys_time_model e, DBA_HIST_SNAPSHOT s, v$parameter p, v$instance i
where s.snap_id = e.snap_id
 and e.instance_number = s.instance_number
 and to_char(e.instance_number) like nvl('&instance_number',to_char(i.instance_number))
 and stat_name             = 'DB time'
 and p.name = 'cpu_count'
)
where  begin_snap between nvl('&begin_snap_id',(select max(snap_id) from DBA_HIST_SNAPSHOT)-100) and nvl('&end_snap_id',99999999)
and begin_snap=end_snap-1
order by begin_snap
)
/

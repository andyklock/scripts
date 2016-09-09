REM $Header: v1.0 dbtimeaas.sql 2016/02/03 andy.klock $
----------------------------------------------------------------------------------------
--
-- File name:   dbtimeaas.sql
-- Purpose:     Find busiest time periods in AWR.
-
-- Author:      Kerry Osborne
--
-- Usage:       This scripts prompts for three values, all of which can be left blank.
--
--              instance_number: set to limit to a single instance in RAC environment
--
--              begin_snap_id: set it you want to limit to a specific range, defaults to 0
--
--              end_snap_id: set it you want to limit to a specific range, defaults to 99999999
--
--              Added AAS --Andy Klock
--
--
---------------------------------------------------------------------------------------
set lines 155
col dbtime for 999,999.99
col begin_timestamp for a40
col aas for 999,999.99
select * from (
select begin_snap, 
       end_snap, 
       begin_timestamp,  
       inst, 
       a/1000000/60 DBtime,
       (a/1000000/60)/(EXTRACT(HOUR FROM end_timestamp - begin_timestamp) * 60 
                                  + EXTRACT(MINUTE FROM end_timestamp - begin_timestamp) 
                                  + EXTRACT(SECOND FROM end_timestamp - begin_timestamp) / 60) aas  from
(
select
 e.snap_id end_snap,
 lag(e.snap_id) over (order by e.instance_number,e.snap_id) begin_snap,
 lag(s.begin_interval_time) over (order by e.instance_number,e.snap_id) begin_timestamp,
 lag(s.end_interval_time) over (order by e.instance_number,e.snap_id) end_timestamp,
 s.instance_number inst,
 e.value,
 nvl(value-lag(value) over (order by e.instance_number,e.snap_id),0) a
from dba_hist_sys_time_model e, DBA_HIST_SNAPSHOT s
where s.snap_id = e.snap_id
 and e.instance_number = s.instance_number
 and to_char(e.instance_number) like nvl('&instance_number',to_char(e.instance_number))
 and stat_name             = 'DB time'
)
where  begin_snap between nvl('&begin_snap_id',0) and nvl('&end_snap_id',99999999)
and begin_snap=end_snap-1
order by dbtime desc
)
where rownum < 31
/
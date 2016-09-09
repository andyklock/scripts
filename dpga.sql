REM $Header: v1.0 dpga.sql 2016/03/17 andy.klock $
REM Purpose: Show PGA usage in AWR
SELECT begin_interval_time, dp.instance_number,Round(Value/1024/1024/1024,1) AS pga_allocated_gb 
FROM dba_hist_pgastat dp, dba_hist_snapshot ss 
where ss.snap_id = dp.snap_id and 
      name = 'total PGA allocated' and
      ss.instance_number = dp.instance_number and
      begin_interval_time > sysdate - nvl('&days_back',999) and
      ss.instance_number like nvl('&instance_number',to_char(ss.instance_number))  
ORDER BY begin_interval_time, ss.instance_number;

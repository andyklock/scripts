REM $Header: v1.0 inst.sql 2015/11/25 andy.klock $
REM Purpose: simple script to list instance information
select inst_id, host_name, startup_time from gv$instance order by inst_id;
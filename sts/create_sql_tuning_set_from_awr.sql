REM $Header: v1.0 create_sql_tuning_set_from_awr.sql 2016/08/25 andy.klock $

set echo on
set serveroutput on;
set linesize 200;
set time on timing on;

@params

-- sets instance name and snap_time for log
column instance_name new_val instance_name
column snap_time new_val snap_time
column sqlset_uniq_identifier new_val sqlset_uniq_identifier

select instance_name, 
       to_char(sysdate,'YYYYMMDDhh24miss') snap_time, 
	   trim(ora_hash(to_char(sysdate,'YYYYMMDDhh24miss'),100000)) sqlset_uniq_identifier 
from v$instance;

spool create_sql_tuning_set_from_awr_&&snap_time._&&sqlset_uniq_identifier..log;

sho user
select global_name from global_name;

select min(snap_id),max(snap_id) from dba_hist_snapshot;


DECLARE
  l_sqlset_name VARCHAR2(30);
  l_description VARCHAR2(256);
  sts_cur       SYS.DBMS_SQLTUNE.SQLSET_CURSOR;

  l_parsing_schema_name_list VARCHAR2(32767);
  l_snap_begin NUMBER;
  l_snap_end   NUMBER;

BEGIN
  l_sqlset_name := '&&sqlset_tag._AWR_&&sqlset_uniq_identifier';

  -- Dan Fink code that converts comma delimited strings into something we can use
  l_parsing_schema_name_list:=UPPER(CHR(39)||REPLACE('&&parsing_schemas',',',CHR(39)||','||CHR(39))||CHR(39));
  l_description := 'SQL Tuning Set - AWR captured for &&sqlset_tag';

  BEGIN
    DBMS_OUTPUT.put_line('dropping sqlset: '||l_sqlset_name);
    SYS.DBMS_SQLTUNE.drop_sqlset (
      sqlset_name  => l_sqlset_name,
      sqlset_owner => upper('&&sqlset_owner') );
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.put_line(SQLERRM||' while trying to drop STS: '||l_sqlset_name||' (safe to ignore)');
  END;

  l_sqlset_name :=
  SYS.DBMS_SQLTUNE.create_sqlset (
    sqlset_name  => l_sqlset_name,
    description  => l_description,
    sqlset_owner => upper('&&sqlset_owner') );
  DBMS_OUTPUT.put_line('created sqlset: '||l_sqlset_name);

  select min(snap_id),max(snap_id) into l_snap_begin, l_snap_end from dba_hist_snapshot;

  OPEN sts_cur FOR
    SELECT VALUE(p)
      FROM TABLE(DBMS_SQLTUNE.select_workload_repository(l_snap_begin, l_snap_end,
      'parsing_schema_name in ('||l_parsing_schema_name_list||') AND loaded_versions > 0', NULL, NULL, NULL, NULL, 1, NULL, 'ALL')) p;

  SYS.DBMS_SQLTUNE.load_sqlset (
    sqlset_name     => l_sqlset_name,
    sqlset_owner    => '&&sqlset_owner',
    populate_cursor => sts_cur );
  DBMS_OUTPUT.put_line('loaded sqlset: '||l_sqlset_name);

  CLOSE sts_cur;
END;
/

set echo off

undef sqlset_owner parsing_schemas sqlset_tag 

spoo off

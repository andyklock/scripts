# $Header: v1.0 drop_baselines.sql 2016/08/25 andy.klock $
set echo on
set serveroutput on
set linesize 20
set time on timing on
spool drop_baselines.log;
sho user
select global_name from global_name;

ACC sql_handle PROMPT 'Enter SQL Handle: ';

ACC plan_name PROMPT 'Enter Plan Name: ';

DECLARE
  l_plans_dropped  PLS_INTEGER;
BEGIN


   l_plans_dropped := DBMS_SPM.drop_sql_plan_baseline(
    sql_handle      => '&sql_handle',
    plan_name       => nvl('&plan_name',null));

END;
/

SET ECHO OFF;

spoo off

UNDEF sql_handle plan_name



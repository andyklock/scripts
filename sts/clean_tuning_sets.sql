REM $Header: v1.0 clean_tuning_sets.sql 2016/07/26 andy.klock $
REM Purpose: Destructive script that drops all tuning sets for an owner
set echo on
set serveroutput on;
set linesize 200;
set time on timing on;
spool clean_tuning_sets.log;
sho user
select global_name from global_name;
ACC sqlset_owner PROMPT 'Enter SQL Sets Owner you want to remove: ';

select SQLSET_NAME, SQLSET_OWNER, count(*) from dba_sqlset_statements group by SQLSET_NAME, SQLSET_OWNER;

begin

  for rec in (select SQLSET_NAME, count(*) from dba_sqlset_statements where sqlset_owner = '&&sqlset_owner' group by SQLSET_NAME)
  LOOP
    SYS.DBMS_SQLTUNE.drop_sqlset(rec.sqlset_name, '&&sqlset_owner');
  END LOOP;
end;
/

select SQLSET_NAME, SQLSET_OWNER, count(*) from dba_sqlset_statements group by SQLSET_NAME, SQLSET_OWNER;

undefine sqlset_owner

spoo off

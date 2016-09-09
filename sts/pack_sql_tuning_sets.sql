REM $Header: v1.0 pack_sql_tuning_sets.sql 2016/08/25 andy.klock $
set echo on
set serveroutput on;
set linesize 200;
set time on timing on;
spool pack_sql_tuning_sets.log;
sho user
select global_name from global_name;

@params

SET SERVEROUT ON;

DROP TABLE &&sqlset_owner..spm_stgtab_sts;

BEGIN
 DBMS_SQLTUNE.create_stgtab_sqlset(
   table_name      => 'SPM_STGTAB_STS', 
   schema_name     => upper('&&sqlset_owner'),
   tablespace_name => upper('&&tablespace_name'));
END;
/

BEGIN
  DBMS_SQLTUNE.pack_stgtab_sqlset (
   sqlset_owner         => upper('&&sqlset_owner'),
   sqlset_name          => '&&sqlset_tag%',
   staging_table_name   => 'SPM_STGTAB_STS',
   staging_schema_owner => upper('&&sqlset_owner'));
END;
/

select count(*) from &&sqlset_owner..spm_stgtab_sts;
UNDEF sqlset_name sqlset_owner tablespace_name

set echo off

spoo off

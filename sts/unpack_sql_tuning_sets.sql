REM $Header: v1.1 unpack_sql_tuning_sets.sql 2016/08/30 andy.klock $
set echo on
set serveroutput on;
set linesize 200;
set time on timing on;
spool unpack_sql_tuning_sets.log;
sho user
select global_name from global_name;

@params

DROP TABLE &&sqlset_owner..spm_stgtab_sts;

BEGIN
 DBMS_SQLTUNE.create_stgtab_sqlset(
   table_name      => 'SPM_STGTAB_STS',
   schema_name     => upper('&&sqlset_owner'),
   tablespace_name => upper('&&tablespace_name'));
END;
/


PRO Please execute the import step and then hit enter
pause

UPDATE &&sqlset_owner..spm_stgtab_sts SET owner = '&&sqlset_owner';

COL sqlset_name NEW_V sqlset_name;

BEGIN
  DBMS_SQLTUNE.unpack_stgtab_sqlset (
   sqlset_name          => '&&sqlset_tag%',
   sqlset_owner         => '&&sqlset_owner',
   replace              => TRUE,
   staging_table_name   => 'SPM_STGTAB_STS',
   staging_schema_owner => '&&sqlset_owner' );
END;
/

SET ECHO OFF;

spoo off

UNDEF sqlset_owner


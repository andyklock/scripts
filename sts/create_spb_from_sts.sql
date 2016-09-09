REM $Header: 215187.1 create_spb_from_sts.sql 11.4.5.8 2013/05/10 carlos.sierra $
REM $Header: v1.3 create_spb_from_sts.sql andy.klock $
REM Modified by andy.klock on 2016/07/12 
REM Removed extraneous prompts
REM Version 3 adds spool

set echo on
set serveroutput on;
set linesize 200
set time on timing on;

spool create_spb_from_sts_PTR_v2..log;

sho user
select global_name from global_name;


ACC sql_id PROMPT 'Enter SQL_ID: ';

SELECT sqlset_name, sqlset_owner,plan_hash_value /* exclude_me */
  FROM dba_sqlset_statements
 WHERE sql_id = '&&sql_id.';

ACC sqlset_name PROMPT 'Enter SQL Set Name: '

SELECT sqlset_owner, plan_hash_value /* exclude_me */
  FROM dba_sqlset_statements
 WHERE sql_id = '&&sql_id.'
   AND sqlset_name = '&&sqlset_name.';

ACC sqlset_owner PROMPT 'Enter SQL Set Owner: ';

SELECT plan_hash_value /* exclude_me */
  FROM dba_sqlset_statements
 WHERE sql_id = '&&sql_id.'
   AND sqlset_name = '&&sqlset_name.'
   AND sqlset_owner = '&&sqlset_owner.';

ACC plan_hash_value PROMPT 'Enter optional Plan Hash Value: ';

VAR plans NUMBER;

BEGIN
  :plans := DBMS_SPM.load_plans_from_sqlset (
    sqlset_name  => '&&sqlset_name.',
    sqlset_owner => '&&sqlset_owner.',
	fixed        => 'YES',
    basic_filter => 'sql_id = ''&&sql_id.'' AND plan_hash_value = NVL(TO_NUMBER(''&&plan_hash_value.''), plan_hash_value)' );
END;
/

PRINT plans;

SET ECHO OFF;

UNDEF sqlset_name sqlset_owner sql_id plan_hash_value

spoo off

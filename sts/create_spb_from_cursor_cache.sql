REM $Header: v1.0 create_spb_from_cursor_cache.sql andy.klock 2017-03-30$

set echo on
set serveroutput on;
set linesize 200
set time on timing on;

spool create_spb_from_cursor_cache..log;

sho user
select global_name from global_name;


ACC sql_id PROMPT 'Enter SQL_ID: ';

ACC plan_hash_value PROMPT 'Enter PLAN_HASH_VALUE: '

declare
  ret binary_integer;
begin
  ret := dbms_spm.load_plans_from_cursor_cache(
     sql_id=> '&sql_id',
     plan_hash_value=> &plan_hash_value,
     fixed=> 'YES',
     enabled=> 'YES');
end;
/

SET ECHO OFF;

UNDEF sqlset_name sqlset_owner sql_id plan_hash_value

spoo off

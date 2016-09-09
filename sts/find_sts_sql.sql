REM $Header: v1.0 find_sts_sql.sql 2016/08/25 andy.klock $
col sqlset_name for a30
col sqlset_owner for a30

ACC sql_id PROMPT 'Enter SQL_ID: ';

SELECT sqlset_name, sqlset_owner,plan_hash_value /* exclude_me */
  FROM dba_sqlset_statements
 WHERE sql_id = '&&sql_id.';
 
undef SQL_ID

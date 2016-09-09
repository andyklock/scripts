REM $Header: v1.0 display_sts_plan.sql 2016/08/25 andy.klock $
PROMPT Requires ADMINISTER ANY SQL TUNING SET
SELECT * FROM   TABLE(DBMS_XPLAN.DISPLAY_SQLSET(sqlset_name => '&sql_set', sql_id => '&sql_id', sqlset_owner=> '&sqlset_owner',plan_hash_value => '&plan_hash_value', format=> 'ALL'));

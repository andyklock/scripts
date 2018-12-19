REM $Header: v1.0 disable_spb.sql andy.klock $

DECLARE
  l_plans_altered  PLS_INTEGER;
BEGIN
  l_plans_altered := DBMS_SPM.alter_sql_plan_baseline(
    sql_handle      => '&sql_handle',
    plan_name       => '&plan_name',
    attribute_name  => 'enabled',
    attribute_value => 'NO');

  DBMS_OUTPUT.put_line('Plans disabled: ' || l_plans_altered);
END;
/

REM $Header: v1.0 dplan_baseline.sql 2016/06/02 andy.klock $
select * from table( 
    dbms_xplan.display_sql_plan_baseline( 
        sql_handle=>'&sql_handle',
		plan_name=>'&plan_name',
        format=>'ALL'));
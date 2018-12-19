REM $Header: v1.1 create_spb_fake_from_cursor_cache.sql andy.klock $
/*
-- Based off of https://jonathanlewis.wordpress.com/2011/01/12/fake-baselines/
-- The target_sql_id is the SQL that we want to accept the new baseline for
-- The source_sql_id and source_plan_hash_value is the one we want the target to start using 
*/ 

declare
    l_clob  clob;
	l_ret binary_integer; 
begin
    select
        sql_fulltext
    into
        l_clob
    from
        v$sql
    where
        sql_id = '&target_sql_id'
    and child_number = &target_child_number
    ;
 
	l_ret:= dbms_spm.load_plans_from_cursor_cache(
		sql_id          => '&source_sql_id',
		plan_hash_value     => &source_plan_hash_value,
		sql_text        => l_clob,
		fixed           => 'YES',
		enabled         => 'YES'
	);

end;
/


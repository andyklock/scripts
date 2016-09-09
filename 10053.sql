REM $Header: v1.0 10053.sql 2016/08/25 andy.klock $
accept sql_id PROMPT 'Enter SQL_ID you want to trace: ';
accept child_number PROMPT 'Enter the child_number for the cursor: ';
begin
  dbms_sqldiag.dump_trace(p_sql_id=> '&&sql_id', p_child_number=> &child_number, p_component => 'Optimizer', p_file_id=> 'SQL_&&sql_id._10053');
end;
/

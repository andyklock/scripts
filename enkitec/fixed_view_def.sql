select * from v$fixed_view_definition
where view_name like upper('&view_name')
/

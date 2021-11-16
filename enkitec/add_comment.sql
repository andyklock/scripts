set serveroutput on for wrap
set pagesize 9999
set linesize 155
var hval number
accept owner -
       prompt 'Enter value for owner: ' 
accept table_name -
       prompt 'Enter value for table_name: ' 

DECLARE
-- oname varchar2(30) := 'XOXOXOXO';
comment_text varchar2(4000);
full_table_name varchar2(400);
sql_string varchar2(3000);
BEGIN

select comments into comment_text
from dba_tab_comments
where owner = upper('&&owner')
and table_name = upper('&&table_name');

full_table_name := '&&owner'||'.'||'&&table_name';
sql_string := 'comment on table '||full_table_name||' is '''||comment_text||'''';
execute immediate sql_string;

   dbms_output.put_line(' ');
   dbms_output.put_line(sql_string);

END;
/
undef owner
undef table_name


col name for a30
col owner for a30

set termout on
set serveroutput on
set feedback off
set verify off

-- start
column 1 new_value 1 noprint
select '' "1" from dual where rownum = 0;
define param = &1 "%"
-- end

select name,owner,created,statement_count from dba_sqlset where name like '%&param%' order by created;

undef param 1
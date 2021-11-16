----------------------------------------------------------------------------------------
--
-- File name:   flush_sql10.sql
--
-- Purpose:     Flush a single SQL statement.
-
-- Author:      Kerry Osborne
--
-- Usage:       This scripts prompts for two values.
--
--              sql_id: the sql_id of a statement that is in the shared pool (v$sqlarea)
--
--              child_number: a valid child_number for the given statement (v$sql) 
--                            - child_number defaults to 0
--
-- Description: This scripts creates an outline on the specified statement and then 
--              attempts to drop the outline. This has the side effect of flushing the 
--              statement from the shared pool. See kerryosborne.oracle-guy.com for 
--              additional information.
--
---------------------------------------------------------------------------------------
-- this is here to attempt to avoid the "ORA-03113: end-of-file on communication channel" error
-- (per metalink) to workaround Bug 5454975 (supposedly fixed 10.2.0.4)
alter session set use_stored_outlines=true;

set serveroutput on for wrap
set pagesize 9999
set linesize 155
var hval number
accept sql_id -
       prompt 'Enter value for sql_id: ' 
accept child_number -
       prompt 'Enter value for child_number: ' - 
       default 0

DECLARE

   name1 varchar2(30);
   sql_string varchar2(300);

BEGIN

   select hash_value into :hval
   from v$sqlarea 
   where sql_id like '&&sql_id';


   DBMS_OUTLN.create_outline(
    hash_value    => :hval, 
    child_number  => &&child_number);
--
-- The next step is a little dangerous,
-- it drops the last outline created (as long as it was create in the last 5 seconds or so)
-- Also note that it appears the category must be default to flush the statement comepletely
--
   select 'drop outline '||name,name into sql_string, name1
   from dba_outlines 
   where timestamp = (select max(timestamp) from dba_outlines)
   and timestamp > sysdate-(5/86400);
   dbms_output.put_line(' ');

   execute immediate sql_string;

   dbms_output.put_line('SQL Statement '||'&&sql_id'||' flushed.');

END;
/
undef sql_id
undef child_number


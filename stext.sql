REM $Header: v1.0 stext.sql 2012/04/13 andy.klock $
REM Purpose: list sql_text 
select sql_text from v$sql where sql_id ='&sql_id';
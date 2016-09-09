REM $Header: v1.1 stextf.sql 2016/03/12 andy.klock $
REM Purpose: show full text
select replace(sql_fulltext,',',','||chr(10)) from v$sql where sql_id ='&sql_id';
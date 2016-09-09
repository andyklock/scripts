REM $Header: v1.0 dstext.sql 2016/03/12 andy.klock $
REM Purpose: show full text available in AWR 
select sql_text from dba_hist_sqltext where sql_id ='&sql_id';
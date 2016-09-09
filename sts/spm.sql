REM $Header: v1.0 spm.sql 2016/07/26 andy.klock $
REM Purpose: Lists available sqlsets and numbers of associated statements with each
col SQLSET_NAME for a30
col SQLSET_OWNER for a30
col OWNER for a30

PROMPT Number of cursors for
sho user
select count(*) from v$sql where parsing_schema_name = USER;

select SQLSET_NAME, SQLSET_OWNER, count(*) from dba_sqlset_statements group by SQLSET_NAME, SQLSET_OWNER order by 2,1;
select owner from dba_tables where table_name = 'SPM_STGTAB_STS';

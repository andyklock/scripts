col sql_sub for a100
select sql_id,substr(sql_text,0,100) sql_sub,length(sql_text) from dba_hist_sqltext where sql_text like '%&1%' order by 3;
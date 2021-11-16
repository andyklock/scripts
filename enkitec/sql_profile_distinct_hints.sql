set lines 155
col hint for a50 trunc
select hint, count(*) from (
select regexp_replace(attr_val,'\(.*$') hint -- eliminate ( to end of line
from dba_sql_profiles p, sqlprof$attr h
where p.signature = h.signature
and p.category = h.category
and name like ('&profile_name')
)
group by hint
order by hint
/

set lines 155
set pages 9999
col sql_text for a80
!echo
!echo "*** This script searchs the shared pool for SQL stataments with How_Many (or more) distinct plans."
-- !echo
select sql_id,  count(distinct plan_hash_value) distinct_plans, sql_text
from v$sql
group by sql_id, sql_text
having count(distinct plan_hash_value) >= &how_many
/

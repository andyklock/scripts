select distinct parsing_schema_name, sa.sql_id, sp.plan_hash_value, cost
from v$sql_plan sp, v$sqlarea sa
where sp.sql_id = sa.sql_id
and parsing_schema_name like nvl('&parsing_user',parsing_schema_name)
and cost like nvl(to_number('&cost'),to_number(cost))
and sp.plan_hash_value like nvl('&plan_hash_value',sp.plan_hash_value)
and parent_id is null
and parsing_schema_name not in ('SYS','SYSTEM','DBSNMP','SYSMAN')
order by 4 desc
/


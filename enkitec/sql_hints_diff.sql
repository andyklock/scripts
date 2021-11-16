----------------------------------------------------------------------------------------
--
-- File name:   sql_hints_diff.sql
--
-- Purpose:     Show differences in outline hints between two cursors.
--
-- Author:      Kerry Osborne
--
-- Usage:       This scripts prompts for four values.
--
--              sql_id: the sql_id of the first statement (must be in the shared pool)
--
--              child_no: the child_no of the first statement from v$sql
--
--              sql_id_2: the sql_id of the second statement (must be in the shared pool)
--
--              child_no_2: the child_no of the second statement from v$sql
--
--
-- Description: 
--
--              Pulls Outline Hints from the OTHER_XML field of V$SQL_PLAN.
--              May be useful in seeing what's different between two plans.
--
--              See kerryosborne.oracle-guy.com for additional information.
---------------------------------------------------------------------------------------
select
extractvalue(value(d), '/hint') as outline_hints
from
xmltable('/*/outline_data/hint'
passing (
select
xmltype(other_xml) as xmlval
from
v$sql_plan
where
sql_id like nvl('&sql_id',sql_id)
and child_number = &child_no
and other_xml is not null
)
) d
minus
select
extractvalue(value(d), '/hint') as outline_hints
from
xmltable('/*/outline_data/hint'
passing (
select
xmltype(other_xml) as xmlval
from
v$sql_plan
where
sql_id like nvl('&sql_id_2',sql_id)
and child_number = &child_no_2
and other_xml is not null
)
) d
;

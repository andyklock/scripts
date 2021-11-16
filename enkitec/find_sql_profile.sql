select
        name, rat.attr1
from
        wri$_adv_tasks          tsk,
        wri$_adv_rationale      rat
where
rat.task_id   = tsk.id
and rat.attr1 is not null
and name like nvl('&name',name)
and rat.attr1 like nvl('&hint_text',rat.attr1)
order by 1
/


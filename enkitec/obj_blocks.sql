select file_id, block_id as start_block, (block_id + blocks - 1) as end_block, blocks
from dba_extents 
where owner like nvl('&owner',owner)
and segment_name like nvl('&segment_name','doda')
order by file_id, start_block
;

col owner for a30
col segment_name for a30
col orig_size_megs for 999,999.9
col in_mem_size_megs for 999,999.9
col megs_not_populated for 999,999.9
col comp_ratio for 99.9
compute sum of in_mem_size_megs on report
break on report

SELECT v.owner, v.segment_name,
v.bytes/(1024*1024) orig_size_megs,
v.inmemory_size/(1024*1024) in_mem_size_megs,
(v.bytes - v.bytes_not_populated) / v.inmemory_size comp_ratio,
v.bytes_not_populated/(1024*1024) megs_not_populated
FROM v$im_segments v
where owner like nvl('&owner',owner)
and segment_name like nvl('&segment_name',segment_name);

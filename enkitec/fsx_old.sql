set verify off
set lines 190
col inst format 9999
col sid format 999
col sql_text format a70 trunc
col sid format 999
col child_number format 99999 heading CHILD
col execs format 9,999,999
col avg_etime format 9,999,999.99
col avg_cpu  format 9,999,999.99
col avg_lio format 999,999,999
col avg_pio format 999,999,999
col "IO_SAVED_%" format 999.99
col avg_px format 999
col offloadable for a11

accept sqltext -
       prompt 'Enter value for sql_text: '
accept sqlid  -
       prompt 'Enter value for sql_id: '
accept instid  -
       prompt 'Enter value for inst_id: '

set feedback off
variable sql_id  varchar2(30)
variable sql_text  varchar2(80)
variable inst_id  varchar2(10)
exec :sql_id := '&&sqlid';
exec :sql_text := '&&sqltext';
exec :inst_id := '&&instid';
set feedback on

select inst_id inst, sql_id, child_number, plan_hash_value plan_hash, executions execs,
(elapsed_time/1000000)/decode(nvl(executions,0),0,1,executions) avg_etime,
--decode(IO_CELL_OFFLOAD_ELIGIBLE_BYTES,0,buffer_gets/decode(nvl(executions,0),0,1,executions),null) avg_lio,
--decode(IO_CELL_OFFLOAD_ELIGIBLE_BYTES,0,disk_reads/decode(nvl(executions,0),0,1,executions),null) avg_pio,
px_servers_executions/decode(nvl(executions,0),0,1,executions) avg_px,
decode(IO_CELL_OFFLOAD_ELIGIBLE_BYTES,0,'No','Yes') Offloadable,
decode(IO_CELL_OFFLOAD_ELIGIBLE_BYTES,0,0,
100*(IO_CELL_OFFLOAD_ELIGIBLE_BYTES-IO_INTERCONNECT_BYTES)
/decode(IO_CELL_OFFLOAD_ELIGIBLE_BYTES,0,1,IO_CELL_OFFLOAD_ELIGIBLE_BYTES)) "IO_SAVED_%",
sql_text
from gv$sql s
where upper(sql_text) like upper(nvl(:sql_text,sql_text))
and sql_text not like 'BEGIN :sql_text := %'
and sql_id like nvl(:sql_id,sql_id)
and inst_id like nvl(:inst_id,inst_id)
order by 1, 2, 3
/

undef sqlid
undef sqltext
undef instid
undef sql_id
undef sql_text
undef inst_id

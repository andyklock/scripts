/* 
   This script prompts for an owner and a tbale name. It then created two new tables 
   - orignal_table_name_BAD and orignal_table_name_SAVED. If either if these tables exist, 
   they are dropped and then recreated. The script then gets a list of extents and blocks
   associated with the table and loops through each block, attempting to select records by
   the rowid and inserts them into the orignical_table_name_SAVED table. Errors are inserted 
   into the original_table_name_BAD table.

   Kerry Osborne - Enkitec
*/

prompt 
Prompt WARNING: This script may issue a DROP TABLE command. Do not execute it unless you have read through it
Prompt          and are comfortable you know what it does.
Prompt
accept a prompt "Ready? (hit ctl-C to quit)  "
set serveroutput on format wrapped
declare

debug_flag varchar2(1) :='N';
x number := 0;
y number := 0;
v_maxrows number := 200; -- 200 is maximum number of rows per block 
v_old_rowid varchar2(30);
v_owner_name varchar2(30) := upper('&owner_name');
v_table_name varchar2(30) := upper('&table_name');
v_bad_table varchar2(40);
v_saved_table varchar2(40);
v_full_table_name varchar2(30);
v_object_id number := 0;
v_sql_insert_saved varchar(256);
v_temp number;
v_last_block number := 0;

e_invalid_rowid exception;
pragma exception_init(e_invalid_rowid,-1410);
e_missing_file exception;
pragma exception_init(e_missing_file,-376);
e_obj_no_longer_exists exception;
pragma exception_init(e_obj_no_longer_exists,-8103);

cursor v_sql_get_blocks is 
select file_id, block_id as start_block, (block_id + blocks - 1) as end_block
from dba_extents where upper(owner) = v_owner_name and segment_name = v_table_name
order by file_id, block_id
;

begin 
v_bad_table := v_table_name||'_BAD';
v_saved_table := v_table_name||'_SAVED';

select object_id into v_object_id
from dba_objects
where owner = v_owner_name
and object_name = v_table_name
;

begin -- block to create saved table
  select 1 into v_temp
  from dba_tables
  where owner = v_owner_name
  and table_name = v_saved_table;
  if debug_flag = 'Y' then dbms_output.put_line('dropping '||v_owner_name||'.'||v_saved_table); end if;
  execute immediate 'drop table '||v_owner_name||'.'||v_table_name||'_SAVED';
  if debug_flag = 'Y' then dbms_output.put_line('creating '||v_owner_name||'.'||v_saved_table); end if;
  execute immediate 'create table '||v_owner_name||'.'||v_table_name||'_SAVED as select * from '||v_owner_name||'.'||v_table_name||
                    ' where 1=2';
exception when no_data_found then
  if debug_flag = 'Y' then dbms_output.put_line('creating '||v_owner_name||'.'||v_saved_table); end if;
  execute immediate 'create table '||v_owner_name||'.'||v_table_name||'_SAVED as select * from '||v_owner_name||'.'||v_table_name||
                    ' where 1=2';
end;

begin -- block to create bad table
  select 1 into v_temp
  from dba_tables
  where owner = v_owner_name
  and table_name = v_bad_table;
  if debug_flag = 'Y' then dbms_output.put_line('dropping '||v_owner_name||'.'||v_bad_table); end if;
  execute immediate 'drop table '||v_owner_name||'.'||v_table_name||'_BAD';
  if debug_flag = 'Y' then dbms_output.put_line('creating '||v_owner_name||'.'||v_bad_table); end if;
  execute immediate 'create table '||v_owner_name||'.'||v_table_name||'_BAD (old_rowid varchar2(30), '||
                    ' old_file number, old_object number, old_block number, old_row number, error_message varchar2(300))';
exception when no_data_found then
  if debug_flag = 'Y' then dbms_output.put_line('creating '||v_owner_name||'.'||v_bad_table); end if;
  execute immediate 'create table '||v_owner_name||'.'||v_table_name||'_BAD (old_rowid varchar2(30), '||
                    ' old_file number, old_object number, old_block number, old_row number, error_message varchar2(300))';
end;

v_full_table_name := v_owner_name||'.'||v_table_name;

v_sql_insert_saved := 'insert into '||v_owner_name||'.'||v_saved_table||' select * from '||v_full_table_name||
                      ' where ROWID = dbms_rowid.rowid_create(1, :b_obj, :b_file, :b_blk, :v_row)';


for v_uetrec in v_sql_get_blocks loop

        for v_blk in v_uetrec.start_block..v_uetrec.end_block loop
                 if debug_flag = 'Y' then dbms_output.put_line(v_uetrec.file_id||'.'||v_blk); end if;
                 for v_row in 0..v_maxrows loop 
                        v_old_rowid := v_uetrec.file_id||'.'||v_blk||'.'||v_row;
                        begin 
                             execute immediate v_sql_insert_saved
                               using v_object_id, v_uetrec.file_id, v_blk, v_row;
                             if debug_flag = 'Y' then
                               dbms_output.put_line(v_old_rowid);
                             end if;
                        exception when e_missing_file then 
                          if debug_flag = 'Y' then
                            DBMS_OUTPUT.put_line (DBMS_UTILITY.FORMAT_ERROR_STACK||' '||v_old_rowid);
                          else
                            if v_blk != v_last_block then -- only insert one bad record per block
                               execute immediate
                                  'insert into '||v_owner_name||'.'||v_bad_table||' values'||
                                  '(:b_rowid,:b_obj,:b_file,:b_blk,:b_row,:b_error)'
                                  using v_old_rowid, v_object_id, v_uetrec.file_id, v_blk, v_row, DBMS_UTILITY.FORMAT_ERROR_STACK;
                               y := y+1;
                               v_last_block := v_blk;
                            end if;
                          end if;
                        when e_invalid_rowid then null;
                        when e_obj_no_longer_exists then null;
                        when no_data_found then null;
                        when others then 
                          if debug_flag = 'Y' then
                            DBMS_OUTPUT.put_line (DBMS_UTILITY.FORMAT_ERROR_STACK||' '||v_old_rowid);
                          else
                               execute immediate
                                  'insert into '||v_owner_name||'.'||v_bad_table||' values'||
                                  '(:b_rowid,:b_obj,:b_file,:b_blk,:b_row,:b_error)'
                                  using v_old_rowid, v_object_id, v_uetrec.file_id, v_blk, v_row, DBMS_UTILITY.FORMAT_ERROR_STACK;
                               y := y+1;
                          end if;
                        end;
                  end loop; -- end of row-loop
         commit; -- save after each block
         end loop; -- end of block-loop
end loop; -- end of uet-loop

execute immediate
'select count(*) from '||v_owner_name||'.'||v_saved_table
into x;

dbms_output.put_line(chr(0));
dbms_output.new_line;
dbms_output.put_line('Saved '||x||' records in '||v_saved_table||'.');
dbms_output.put_line(y||' bads records in '||v_bad_table||'.');

end;
/
undef a

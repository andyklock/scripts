
- As suggested in Metalink Note: 92202.1
--
-- Note this script exchanges the hints between two outlines.
-- It does not drop either of the outlines.
--
-- Also, as pointed out by Jonathan Lewis is an article about outlines, 
-- the outln.ol$ needs to be updated with the proper number of hints.
-- Otherwise the outline may become damaged, specifically by doing an 
-- export/import. This is not mentioned in the Metalink note.


declare
fromname varchar2(50);
toname varchar2(50);
sql_string varchar2(100);
begin
fromname := '&from_name';
toname := '&to_name';
dbms_output.put_line('from_name: '||fromname);
dbms_output.put_line('to_name: '||toname);

UPDATE OUTLN.OL$HINTS
SET OL_NAME=DECODE(OL_NAME, fromname, toname, toname, fromname)
WHERE OL_NAME IN (fromname,toname);

update outln.ol$ ol1
set hintcount = (
        select  count(*) 
        from    outln.ol$hints ol2
        where   ol2.ol_name = ol1.ol_name
        )
where
	ol1.ol_name in (fromname,toname)
;

-- Apparently, it is necessary to disable and then reenable the hint to get the optimiser to pick it up
-- dbms_outln.refresh_outline_cache doesn't seem to do the trick
-- nor does hinting a table to flush the SQL statement
-- flushing the shared pool works though!
--
sql_string := 'alter outline '||fromname||' disable';
execute immediate sql_string;
sql_string := 'alter outline '||fromname||' enable';
execute immediate sql_string;
sql_string := 'alter outline '||toname||' disable';
execute immediate sql_string;
sql_string := 'alter outline '||toname||' enable';
execute immediate sql_string;

end;
/
Commit;


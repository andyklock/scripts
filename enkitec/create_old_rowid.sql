create or replace function old_rowid (p_rowid rowid) 
return varchar as

  rowid_type NUMBER;
  object_id NUMBER;
  fileno NUMBER;
  blockno   NUMBER;
  rowno  NUMBER;

BEGIN

   dbms_rowid.rowid_info(p_rowid, rowid_type, object_id, fileno, blockno, rowno);
/*
   dbms_output.put_line('Row Typ-' || TO_CHAR(rowid_type));
   dbms_output.put_line('Obj No-' || TO_CHAR(object_id));
   dbms_output.put_line('RFNO-' || TO_CHAR(fileno));
   dbms_output.put_line('Block No-' || TO_CHAR(blockno));
   dbms_output.put_line('Row No-' || TO_CHAR(rowno));
*/
return(to_char(fileno)||'.'||to_char(blockno)||'.'||to_char(rowno));

END;
/

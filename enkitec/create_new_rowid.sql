create or replace function new_rowid (p_object_id number, p_old_rowid varchar)
return varchar as

  new_rowid varchar2(30);
  fileno NUMBER;
  blockno   NUMBER;
  rowno  NUMBER;

BEGIN

  fileno := substr(p_old_rowid,1,instr(p_old_rowid,'.')-1);
  blockno := substr(p_old_rowid,instr(p_old_rowid,'.')+1,instr(p_old_rowid,'.',1,2)-instr(p_old_rowid,'.'));
  rowno := substr(p_old_rowid,instr(p_old_rowid,'.',1,2)+1,100);
  new_rowid := DBMS_ROWID.ROWID_CREATE(1, p_object_id, fileno , blockno , rowno);

  return(new_rowid);

END;
/

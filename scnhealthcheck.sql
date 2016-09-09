Rem
Rem $Header: rdbms/admin/scnhealthcheck.sql st_server_tbhukya_bug-13498243/8 2012/01/17 03:37:18 tbhukya Exp $
Rem
Rem scnhealthcheck.sql
Rem
Rem Copyright (c) 2012, Oracle and/or its affiliates. All rights reserved. 
Rem
Rem    NAME
Rem      scnhealthcheck.sql - Scn Health check
Rem
Rem    DESCRIPTION
Rem      Checks scn health of a DB
Rem
Rem    NOTES
Rem      .
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    tbhukya     01/11/12 - Created
Rem    andyklock   12/13/15 - modified the script from MOS to use v$database since I don't always 
Rem                           have access to dbms_flashback. Also added "(days)" to signify measurement used
Rem                           Not sure if it's ok to repost but has been very handy
Rem

define LOWTHRESHOLD=10
define MIDTHRESHOLD=62
-- define VERBOSE=FALSE
define VERBOSE=TRUE

set veri off;
set feedback off;

set serverout on
DECLARE
 verbose boolean:=&&VERBOSE;

 BEGIN

 For C in (
  select 
   version, 
   date_time,
--   dbms_flashback.get_system_change_number current_scn,
   (select current_scn from v$database) current_scn,
   indicator
  from
  (
   select
   version,
   to_char(SYSDATE,'YYYY/MM/DD HH24:MI:SS') DATE_TIME,
   (select current_scn from v$database) current_scn,
   ((((
    ((to_number(to_char(sysdate,'YYYY'))-1988)*12*31*24*60*60) +
    ((to_number(to_char(sysdate,'MM'))-1)*31*24*60*60) +
    (((to_number(to_char(sysdate,'DD'))-1))*24*60*60) +
    (to_number(to_char(sysdate,'HH24'))*60*60) +
    (to_number(to_char(sysdate,'MI'))*60) +
    (to_number(to_char(sysdate,'SS')))
    ) * (16*1024)) - (select current_scn from v$database))
   / (16*1024*60*60*24)
   ) indicator
   from v$instance
  ) 
 ) LOOP
  dbms_output.put_line( '-----------------------------------------------------'
                        || '---------' );
  dbms_output.put_line( 'ScnHealthCheck' );
  dbms_output.put_line( '-----------------------------------------------------'
                        || '---------' );
  dbms_output.put_line( 'Current Date: '||C.date_time );
  dbms_output.put_line( 'Current SCN:  '||C.current_scn );
  if (verbose) then
    dbms_output.put_line( 'SCN Headroom: '||round(C.indicator,2) || ' (days)');
  end if;
  dbms_output.put_line( 'Version:      '||C.version );
  dbms_output.put_line( '-----------------------------------------------------'
                        || '---------' );

  IF C.version > '10.2.0.5.0' and 
     C.version NOT LIKE '9.2%' THEN
    IF C.indicator>&MIDTHRESHOLD THEN 
      dbms_output.put_line('Result: A - SCN Headroom is good');
      dbms_output.put_line('Apply the latest recommended patches');
      dbms_output.put_line('based on your maintenance schedule');
      IF (C.version < '11.2.0.2') THEN
        dbms_output.put_line('AND set _external_scn_rejection_threshold_hours='
                             || '24 after apply.');
      END IF;
    ELSIF C.indicator<=&LOWTHRESHOLD THEN
      dbms_output.put_line('Result: C - SCN Headroom is low');
      dbms_output.put_line('If you have not already done so apply' );
      dbms_output.put_line('the latest recommended patches right now' );
      IF (C.version < '11.2.0.2') THEN
        dbms_output.put_line('set _external_scn_rejection_threshold_hours=24 '
                             || 'after apply');
      END IF;
      dbms_output.put_line('AND contact Oracle support immediately.' );
    ELSE
      dbms_output.put_line('Result: B - SCN Headroom is low');
      dbms_output.put_line('If you have not already done so apply' );
      dbms_output.put_line('the latest recommended patches right now');
      IF (C.version < '11.2.0.2') THEN
        dbms_output.put_line('AND set _external_scn_rejection_threshold_hours='
                             ||'24 after apply.');
      END IF;
    END IF;
  ELSE
    IF C.indicator<=&MIDTHRESHOLD THEN
      dbms_output.put_line('Result: C - SCN Headroom is low');
      dbms_output.put_line('If you have not already done so apply' );
      dbms_output.put_line('the latest recommended patches right now' );
      IF (C.version >= '10.1.0.5.0' and 
          C.version <= '10.2.0.5.0' and 
          C.version NOT LIKE '9.2%') THEN
        dbms_output.put_line(', set _external_scn_rejection_threshold_hours=24'
                             || ' after apply');
      END IF;
      dbms_output.put_line('AND contact Oracle support immediately.' );
    ELSE
      dbms_output.put_line('Result: A - SCN Headroom is good');
      dbms_output.put_line('Apply the latest recommended patches');
      dbms_output.put_line('based on your maintenance schedule ');
      IF (C.version >= '10.1.0.5.0' and
          C.version <= '10.2.0.5.0' and
          C.version NOT LIKE '9.2%') THEN
       dbms_output.put_line('AND set _external_scn_rejection_threshold_hours=24'
                             || ' after apply.');
      END IF;
    END IF;
  END IF;
  dbms_output.put_line(
    'For further information review MOS document id 1393363.1');
  dbms_output.put_line( '-----------------------------------------------------'
                        || '---------' );
 END LOOP;
end;
/

col old_rowid for a20
/*
There is a bit mask that indicates level of compression
10000000 (1) = no compression
01000000 (2) = BASIC/OLTP
00100000 (4) = QUERY HIGH
00010000 (8) = QUERY LOW
00001000 (16) = ARCHIVE HIGH
00000100 (32) = ARCHIVE LOW
*/
select 
old_rowid(rowid) old_rowid,
decode(
DBMS_COMPRESSION.GET_COMPRESSION_TYPE ( '&owner', '&table_name', '&rowid'), 
1, 'No Compression',
2, 'Basic/OLTP Compression', 
4, 'HCC Query High',
8, 'HCC Query Low',
16, 'HCC Archive High',
32, 'HCC Archive Low',
'Unknown Compression Level') compression_type
from dual;

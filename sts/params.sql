REM $Header: v1.0 params.sql 2016/08/25 andy.klock $
REM Parameter script to set common variables. Previously this was done similarly to Carlos Sierra's method
REM which relied on SQL Prompts
REM See https://github.com/carlos-sierra/cscripts/archive/master.zip (spm directory) for other SPM scripts

-- SQL Set Owner
define sqlset_owner = ANDY

-- SQL Set Tag
-- Note that a tag should be short and sweet, under 20 chars since I've added additional uniq hashes and AWR|CC tags
-- Like most Oracle objects, Tuning Set names are restricted to 30 characters
define sqlset_tag = Release1.1

-- parsing schema list
-- needs to be comma delimited
define parsing_schemas = ANDY

-- tablespace_name for tuning set staging table 
-- check DBA_TS_QUOTAS

-- tablespace_name for my test vm
--define tablespace_name = USERS


----------------------------------------------------------------------------------------
--
-- File name:   drop_translation.sql
--
-- Purpose:     Drop (actually Deregister) SQL Translation.
--
-- Author:      Kerry Osborne
--
-- Usage:       This scripts prompts for three values.
--
--              translation_profile: the name for the SQL Translation Profile to drop the translation from
--
--              sql_id: the sql_id of the statement to drop from the profile
--
--              sql_text: if the sql_id is null, the sql_text may be manually specified
--
--
-- Description: 
--
--              This script deregisters a SQL statement from a translation profile.
--
--              See kerryosborne.oracle-guy.com for additional information.
---------------------------------------------------------------------------------------
--


accept trans_profile -
       prompt 'Enter value for sql_translation_profile: ' -
       default 'X0X0X0X0'
accept sql_id -
       prompt 'Enter value for sql_id_to_replace: ' -
       default 'X0X0X0X0'
accept sql_text -
       prompt 'Enter value for sql_text_to_replace (null): ' -
       default 'X0X0X0X0'

exec dbms_sql_translator.deregister_sql_translation('&&trans_profile','&&sql_text');

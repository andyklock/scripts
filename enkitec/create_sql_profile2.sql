accept sql_id_from -
       prompt 'Enter value for sql_id to generate profile from: ' -
       default 'X0X0X0X0'
accept child_no_from -
       prompt 'Enter value for child_no to generate profile from: ' 
accept sql_id_to -
       prompt 'Enter value for sql_id to attach profile to: ' -
       default 'X0X0X0X0'
accept child_no_to -
       prompt 'Enter value for child_no to attach profile to: ' 
accept category -
       prompt 'Enter value for category: ' -
       default 'DEFAULT'
accept force_matching -
       prompt 'Enter value for force_matching: ' -
       default 'false'

@rg_sqlprof3 '&sql_id_from' &child_no_from '&sql_id_to' &child_no_to '&category' '&force_matching'
undef sql_id_from
undef child_no_from
undef sql_id_to
undef child_no_to
undef category
undef force_matching


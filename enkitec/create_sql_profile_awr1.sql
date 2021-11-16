accept sql_id -
       prompt 'Enter value for sql_id: ' -
       default 'X0X0X0X0'
accept plan_hash_value -
       prompt 'Enter value for plan_hash_value: ' 
accept category -
       prompt 'Enter value for category: ' -
       default 'DEFAULT'
accept force_matching -
       prompt 'Enter value for force_matching: ' -
       default 'false'

@rg_sqlprof2 '&&sql_id' &&plan_hash_value '&&category' '&&force_matching'
undef sql_id
undef plan_hash_value
undef category
undef force_matching


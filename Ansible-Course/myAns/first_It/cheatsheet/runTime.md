
--extra-vars=VARS (-e Vars)
--forks=NUM (-f Num)
--connection=TYPE (-c type), can be like local 
--check 
--limit=HOSTS or GROUPS, wildcards also possible *.example.com or *app
--force-handlers

# Comes the user settings 
--user=USER (-u User) 
--become (-b ) 
--become-user=USER, define the root user(the default is root)
--aks-become-pass (-k) 
--extra-vars "var1=var1_value"
--extra-vars "@json or yml file" --> not recommended

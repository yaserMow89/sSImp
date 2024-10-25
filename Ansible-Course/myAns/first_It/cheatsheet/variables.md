**General Rules of Thumb for Vars** </br>
&nbsp; 1. Roles should provide sane default values </br>
via the role’s ‘defaults’ variables. These variables will be the fallback in case the
variable is not defined anywhere else in the chain.</br>
&nbsp; 2. Playbooks should rarely define variables (e.g. via set_fact), but rather, vari-
ables should be defined either in included vars_files or, less often, via
inventory.</br>
&nbsp; 3. Only truly host- or group-specific variables should be defined in host or group
inventories.</br>
&nbsp; 4.Dynamic and static inventory sources should contain a minimum of variables,
especially as these variables are often less visible to those maintaining a
particular playbook.</br>
&nbsp; 5. Command line variables (-e) should be avoided when possible. One of the main
use cases is when doing local testing or running one-off playbooks where you
aren’t worried about the maintainability or idempotence of the tasks you’re
running.</br>
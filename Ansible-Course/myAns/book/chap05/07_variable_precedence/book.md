**Precedence**
&nbsp;1. --extra-vars passed in via the command line (these always win, no matter
what).
&nbsp;2. Task-level vars (in a task block).
&nbsp;3. Block-level vars (for all tasks in a block).
&nbsp;4. Role vars (e.g. [role]/vars/main.yml) and vars from include_vars module.
&nbsp;5. Vars set via set_facts modules.
&nbsp;6. Vars set via register in a task.
&nbsp;7. Individual play-level vars: 1. vars_files 2. vars_prompt 3. vars
&nbsp;8. Host facts.
&nbsp;9. Playbook host_vars.
&nbsp;10. Playbook group_vars.
&nbsp;11. Inventory: 1. host_vars 2. group_vars 3. vars
&nbsp;12. Role default vars (e.g. [role]/defaults/main.yml).

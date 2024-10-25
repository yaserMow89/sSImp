
# Ad-Hoc Commands

- Ansible uses forks to run concurrent processes

  - This can be altered by simply using `-f` option and passing the desired number of forks we would like to have while running a playbook
  - For example `-f 1` will run the commands in serial on a fleet of servers

- The option `--limit <ipAddress>` can be used to limit the command to a single host wihtin a host group

# Logging

## `rsyslog`
- Using `rsyslog` all messages are broken into two components:
   - Message *Facility*
      - The associated subsystem that provided the logged message
      - A number of them: `auth, authpriv, cron, daemon, kern, lpr, mail, mark, news, syslog, user, uucp, local10 - local17`
   - Message *Priority*
      - Severity of the message
      - 8 options
      - `0 emerg, 1 alert, 2 crit, 3 error, 4 warn, 5 notice, 6 info, 7 debug`
- Only logs what is actually defined

## `journald`
- `systemd`'s in-memory system logging solution
- All logs from start up to shut down
- With a restart it will be reset
- To see it in a continues mode `journalctl -ef`
   - `e` *end*, jump to the end
   - `f` *follow*, load new logs as they are being generated

- How to filter logs with it?
   - For example to see only Kernel related logs use `-k`
   - `-u` lets to search by **service**
      - For exampel, `journalctl -u sshd` shows logs related to ssh

- To see logs of a certain **priority**
   - `-p` can be used
   - for example `journalctl -p 4`all logs with priority of 4
   - Can also be used with the priority code, `journalctl -p emerg`

- **Persistent** journald logging can also be enabled
   - `/etc/systemd/journald.conf`
   - Uncomment the line `storage=auto`
   - Create the location for logging `/var/log/journal`
   - Change user and group ownershipt to `root:systemd-journal`
   - Change the permissions to `2755`
   - Restart `systemd-journald`

- To see all logs since last boot `-xb`
- Can also be used within a specific time window
   - Can be done using flags `--since` and `--until`
   - The date format is: `yyyy-mm-dd hh:mm:ss`
   - ` journalctl --since '2024-11-25 03:30:00' --until now`

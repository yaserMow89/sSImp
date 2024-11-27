# Services


- In `/etc/systemd/system`:
   - `*.target` or `*.target.wants` refers to various Linux **runlevels**
   - `*.requires` are directories containing unit files for any additional required services

- Unit files are organized into separate sections:
   - `[Unit]` section:
      - Descriptive information and documentation as well as requisites for that particular unit or service
      - `Requires=`: loads alongside the unit
      - `Wants=`: Wants the unit, but failure is tolerated
      - `After=`: Unit is loaded after it
      - `Before=`: Unit is loaded before
      - `RequiresOverridable=`: If started by root, can fail
      - `Requisite=`: The unit must already be loaded
      - `Conficts=`: Unit stops when this unit starts
      - Can use the `systemctl list-dependencies` to see dependencies tree
   - `[Service]` section:
      - How the service is set up and runs

- `/usr/lib/systemd/system`

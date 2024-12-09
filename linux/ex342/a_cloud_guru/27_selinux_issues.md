# SELinux Issues

## SELinux Context
- **Security Architecture** built around a particular file and the **access control** for that particular file
- setools package could be used to work with this
   - Should be installed
- For example looking at the context of `/var/log/pcp` gives `system_u:object_r:pcp_log_t:s0 pmcd`
   - breaking down these components:
      - `system_u` Has system user object
      - In object role `object_r`, works as a placeholder
      - It is assigned `pcp_log_t` mean pcp log type
      - `s0` multi level security, which provides additional security based on leveling

   - Context is not the only component when it comes to SELinux security
      - User mapping
      - Any roles and other factors also impact it, and the can be managed using with *semanage* and *seinfo*

- Has to be installed `setools`

# PAM Issues

- First place to look for authentication configurations is: `/etc/nsswitch.conf`
   - `nsswitch` --> Name Service conf
- PAM module configurations are at: `/etc/pam.d/*`
- Each file can have a couple of columns, and each columns means:
   - **Type** of call being made to pam like `auth, account, password` or `session`
      - Are we authenticating
      - Checks for existence and access of an account
      - Password manages the update of password and changing connectivity to auth
      - Session is session management for the user
   - **Control** is the method used to handle the request of provided type for example `required`
      - Required fails after all modules
      - Requisite fails immediately
      - Sufficient checks for bear minimum requirement of the module
      - Optional any module or information provided that isn't actually used for authentication, like some additional data that needs to be provided
      - Include and Substack, work very similarly and means that all lines in configuration are included
   - **Module** would be in response to the **type** and **control**
   - **args** defines any additional arguments

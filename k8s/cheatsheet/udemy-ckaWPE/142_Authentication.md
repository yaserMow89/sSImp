Authentication
==============

- Access to the Cluster
- Users
   - Humans
      - Admins
      - Developers
      - External source
      - Only can manage service accounts
      ```
      k get sa
      k create sa <name> ...
      ```
   - All *User* Access is managed by API Server
      - Every request should be authenticated by `kube-apiserver` before being served

### How Does `kube-apiserver` preform the Authentication
   - *Static Password File*
      - Usernames and passwords
   - *Static Token File*
      - Usernames and Tokens
   - *Certificates*
   - *Identity Services*
      - LDAP, Kerberos

#### Static *Password* and *Token* file (Not Recommended approach)
   - A list of users and psswords in `csv`
   - Passwords file
      - Four columns
         1. Password
         2. User Name
         3. User ID
         4. Groups (Optional)
      - Pass the filename as an option to the `kube-apiserver` `kube-apiserver --basic-auth-file=<fileName>.csv` and then restart to take effect
         - In case of tokens the option would be `--token-auth-file=<filename>.csv`
      - If the cluster is created using the *kubeadm* tool, then you must modify the pod for `kube-apiserver` and then it will be restarted with the new modifications, must also include the file in the pod as a volume
      - To Authenticate using basic credentials, specify the username and password in a `curl` command like: `curl -v -k https://<masterNodeIP>:6443/api/v1/pods -u "<userName>:<password>"`
         - In case of tokens while performing the authorization `curl -v -k https://<masterNodeIP>:6443/api/v1/pods --header "Authorization: Bearer <token>"`
   - The following is redundant only
   - Similarly a token file can be passed
      - Four Columns
         1. Token
         2. User Name
         3. User ID
         4. Groups (Optional)
      - Passing the file name as option `--token-auth-file=<fileName>.csv`
      - While authenticating specify token as authorization bearer
      ```
      curl -v -k https://<masterNodeIP>:6443/api/v1/pods --header "Authorization: Bearer <token>"
      ```

- Bots

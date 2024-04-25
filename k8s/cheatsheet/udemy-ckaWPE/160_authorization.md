Authorization
=============

- Simply defining distinct access levels
- Restrict users access to their `namespaces`
- Different authorization ways
   1. **Node**
      - `kubeAPI` accessed by *Users* as well as *`kubelet`*
         - `kubelet` accesses `kubeApi` for:
            * *Read*
               - `services`
               - `Endpoints`
               - `Nodes`
               - `Pods`
            * *Write*
               - *Node status*
               - *Pod status*
               - *events*
            * All the above *requests* are handled by *Node* authorizer
               * Earlier it was discussed that the `kubelet` should be part of `SYSTEM:NODES` **group** and have a name prefixed with `system:node` like this `system:node:<nodeName>`
                  - So any requests coming from a user with the name `system:node` and part of the group `SYSTEM:NODES` is authorized by the **Node** authorizer and are granted above mentioned privileges
         - Access within the cluster
   2. **ABAC (Attribute Based Access Control)**
      - **External** access to the `API`
      - Associate a user or group of users with a set of permissions
      - For example we would say that `dev-user` can *view*, *create* and *delete* `pods`
      - It is done by defining a **Policy File** with a set of **Policies** in `json` format
      - Pass the file into the `apiServer`
      - Can be done for every user or group of users
      - Every time making changes, you have to edit the policy file *Manually* and restart the `kube-apiserver`
         * makes the **ABAC** difficult to manage
   3. **RBAC (Role Based Access Control)**
      - Define **ROLE**
         - Grant **Permissions** for the role
         - Associate all the users in that group to that role
      - Easier compared to the **ABAC**
      - Every time changes are required to be made to the **Access** level, we simply modify the **Role**
      - More standard to managing access within the cluster
   4. **Webhook**
      - **Oursourcing** the authorization
      - 3rd party app is going to decide wether a user should be permitted to preform an action or not
         - An example of a 3rd party app would be `open policy agent`
         - The user requests access from `kube-apiserver`
         - `kube-apiServer` asks from the `Open Policy Agent`
         - `kube-apiServer` makes the decision based on the data from the `Open Policy Agent`
   5. **AlwaysAllow**
      - No authorization checks
   6. **AlwaysDeny**
      - Always denies the requests
   - The modes are set using the `--authorization-mode` as an option to the `kube-apiServer`
      - If not set by you, will use `alwaysAllow` by default
      - If *multiple* are defined, the request is authorized against each of the modes specified in `--authorization-mode` in the order specified
      - If a module (For example `node`) denies the request it goes to the next module in the chain, consider the following example
         - the `--authorization-mode=Node,RBAC,Webhook` is passed
         - A user requests access, the `Node` module checks it and since it is not defined in it, passes it to the next module being `RBAC` and this module grants or denies the permissions
         - Once a module approves a request no more `modules` are checked and the user is granted permission

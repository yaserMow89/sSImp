Cluster Roles and RoleBindings
==============================

- Resources are either **cluster wide** or **NameSpace wide**
- **Roles** and **rolebindings** are bound to `nameSpaces`
- What about **cluster wide** resources like
   - `nodes`
   - `pv`
   - `clusterroles`
   - `clusterrolebingings`
   - `certificatesigningrequests`
   - `namespaces`
   - To get a list **un-namespaced** resrouces
   ```
   k api-resources --namespaced=false
   ```

## ClusterRoles and ClusterRoleBingings
- same as *`role`* and *`rolebindings`*, but cluster wide
- Role would be
```
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
   name: <name>
rules:
- apiGroups: [""]
  resources: ["<resources>", ]
  verbs: ["<verbs>"]
# Create it with:
k create -f <fileName>.yml
```
- For linking user to `clusterRole` we should create `clusterRoleBinging`
```
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
   name: <name>
subjects:
- kind: User
  name: <userName>
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: CclusterRole
  name: <clusterRoleName>
  apiGroup: rbac.authorization.k8s.io

# Create it Using
k create -f <fileName>.yml
```

* **NOTE:** ClusterRoles can also be created for **NameSpace** resources as well
   * Doing so the user will have access to that resource(s) accross all **NameSpaces**

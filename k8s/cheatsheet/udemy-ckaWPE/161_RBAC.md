Role Based Access Control
=========================

- How to **create** a `role`
- Done by creating a `role` object

```
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
   name: <role'sName>
rules:
- apiGroups: [""]
  resources: ["<resourceName"]
  verbs: ["<verbsNames>"]
 - apiGroups: [""]
   resources: ["<resourName>"]
   verbs: ["<verbsNames>"]
```
- Fields under `rules` are explained in `159_APIGraphGroups.md`
- can add as many `apiGroups` as you like to
- create it using `k apply -f <roleFileName>.yml`
- Once the role is created you have to **link** the user to that role
   - A new object should be created of `kind: RoleBinding`
   - Links a `user object` to a `role`
```
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
   name: <name>
subjects: # User details
- kind: User
  name: <UserName>
  apiGroup: rbac.authorization.k8s.io
roleRef: # Role details
  kind: Role
  name: <role'sName>
  apiGroup: rbac.authorization.k8s.io
```
- use the `k create -f <roleBindingName>.yml` to create it
- `Role` and `RoleBinding` fall under the scope of *`NameSpaces`*
   - If you want to have a specific `NameSpace` you can define it under the `metadata` field in the definition file
### Some useful commands:
- `k get roles`
- `k get rolebindings <name>`
- `k describe role/rolebinding <name>`
- How to see your access as a user to a particular cluster
   * `k auth can-i <verb> <resource>`
   * `k auth can-i create pods`
   * Even as an *admin* you can check for other users, just pass the `--as <userName>` option to the above command
      - `k auth can-i <verb> <resource> --as <userName>`
   * Also the `nameSpace` can be passed
      - `k auth can-i <verb> <resrouce> --as <userName> --namespace <namespaceName>`
### Limiting access to specific resources by name under specific resource type
- in the `role` definition file, under `.rules.apiGroups.` you can define the field `resourceNames` and define the specific resources by their names, take the following example
```
kind: Role
apiVersion: rbac.authorization.k8s.io/v1
metadata:
   name: <name>
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get", "create", "update"]
  resourceNames: ["<pod1Name>", "<pod2Name>", ...]
```

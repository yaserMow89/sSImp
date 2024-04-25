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
  verbs: ["verbsNames"]
```

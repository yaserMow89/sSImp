Resource Requirements
=====================

The following content are taken from the following links:
[Understanding Kubernetes limits and requests](https://sysdig.com/blog/kubernetes-limits-requests/)

- Limits
   - Maximum
- Requests
   - Minimum guaranteed

- An example would be:
```
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: httpd
  name: httpd
spec:
  replicas: 20
  selector:
    matchLabels:
      app: httpd
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: httpd
    spec:
      containers:
      - image: httpd
        name: httpd
        resources:
          limits:
            memory: 2Gi
            cpu: 1
          requests:
            memory: 100Mi
            cpu: 200m
```
## CPU particularities
- Compressible resource
- A node might have more than 1 core so requesting CPU > 1 is possible

## Memory Particularities
- Non-compressible

## ResourceQuotas
- Tenants
- Can be done like this example:
```
apiVersion: v1
kind: ResourceQuota
metadata:
  name: dev
spec:
  hard:
    limits.cpu: 2
    limits.memory: 4Gi
    requests.cpu: 1
    limits.memory: 3Gi
```
- Can be applied to `namespace` using the command `k apply -f <fileName> --namespace <nsName>`
- ResrouceQuota for a `namespace` can be seen with `k get resourcequota -n <nsName>`

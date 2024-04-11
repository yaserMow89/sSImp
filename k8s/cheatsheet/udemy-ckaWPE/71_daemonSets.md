Daemon Sets
===========

- Like replicaSets
   - One copy of the pod is always present in all nodes in the cluster
   - But one copy of pod on each node, in the cluster
   - A new node, a replica of the pod is added
   - A node is removed, the pod is removed automatically
- Some usecases
   - Monitoring
   - Logging
   - `kube-proxy` can be deployed as a daemon set, in the cluster
   - `weave-net`
- Definition file is:
   - Looks very similar to the `replicaset` definition file
```
apiVersion: apps/v1
kind: DaemonSet
metadata:
   name: <name>
   namespace: <nameForTheNameSpace>
spec:
   selector:
      matchLabels:
         <labelKey>: <labelValue>
   template:
      metadata:
         labels:
            <labelKey>: <labelValue>
      spec:
         containers:
            - image: <imageName>
              name: <containerName>

```

## How does it work?
   - Uses nodeAffinity rules with default scheduler to deliver a pod on each node

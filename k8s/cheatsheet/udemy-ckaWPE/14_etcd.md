

### etcd installation:
   - Can be done in two ways
      * Scratch
         - Downloading the *binary*
         - Installing binary
         - configuring **etcd** as a service manually
            - Options passed to service
               - Currently important option is: `--advertise-client-urls https://${<Internal_IP>}:2379`
                  - Above url should be configured on *kube-api-server* when it is trying to reach the **etcd** server

      * Kubeadm tool
         - Is deployed as a pod in *kube-system* namespace


- An example to get keys in the **etcd** database, run the following on the master node:
```
kubectl exec etcd-<masterNodeName> -n kube-system etcdctl get / --prefix -keys-only
```
- k8s stores data in specific directory structure:
   - *root* directory is *registry* and under that you will find various k8s constructs such as minions (nodes), pods, etc..
- In HA env, you will have multiple masters and will have multiple **etcd** instances
   - In the above circumstances, you ought to make sure the **etcd** instances know about each other
      - This can be achieved by properly configuring **etcd** service configuration
         - `--initial-cluster` option can be used to specify different **etcd** instances

OS Upgrade
==========

- Node down for more than 5 minutes, pods will be terminated on that node
   - K8S considers them as dead
   - **eviction-timeout**
      - The time it waits for a *pod* to come back online
      - `kube-controller-manager --pod-eviction-timeout=5m0s`
      - If a node come back online after the **eviction-timeout** it would be *blank*, no pods
      - Pods part of `replicaSet` are already scheduled on other nodes, and the ones without any `replicaSets` are gone

## *Drain* a Node
- `k drain <nodeName>`
- gracefully terminate the pods on the specific node, and recreate them on other nodes
- Node is `cordoned` --> un-schedulable
   - Should be removed by the admin in order to schedule pods on it
      - `k uncordon <nodeName>`
- `k cordon <nodeName>`
   - Unlike `drain` does not terminate or remove the running pods, just makes sure no new pods are coming on this node 

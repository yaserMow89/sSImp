Node Draining
=============
- [Link](https://kubernetes.io/docs/reference/kubectl/generated/kubectl_drain/) to the original document



- Draining for maintenance
- Node will be marked as unschedulable
   - **Evicts** the pods if the API server otherwise normal **Delete**
   - **Except Mirror** pods
      * Which can't be deleted through the API server

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

ACG video
=========
- `kubectl drain <nodeName>`
- `kubectl drain <nodeName> --ignore-daemonsets`
   * `daemonsets` --> Pods specifically tied to each node
- `kubectl drain <nodeName> --ignore-daemonsets --force`
   * `--froce`  
- `kubectl uncordon <nodeName>`

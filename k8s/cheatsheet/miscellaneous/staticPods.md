Static Pods
===========

The following content are taken from following links:
[Create Static Pods](https://kubernetes.io/docs/tasks/configure-pod-container/static-pod/)

- Managed directly by *kubelet* on a specific node, no *API Server*
- Watched by *kuebelet*, and restarted by *kubelete* if failed, no *control plane*
- Bound to one *kubelet* on a specific node
- One *mirror Pod* on *API Server* for each static pod
   - Means, pods runing on a node are visible by *API Server*, but can't be controlled
- pod name suffixed with the node hostname with a leading hyphen



`kubectl apply -f <FileName>`

`kubectl get pods`
   * `-o wide`
   * `-o yaml` --> Gives everything k8s knows about the object
   * `--watch`or `-w` --> After listing/getting the requested object, watch for changes.


`kubectl describe <object> <objectName>`
   * Give nicely formatted overview of an object
```
   kubectl describe node ip-172-31-6-250.ec2.internal
   kubectl describe pod hello-pod
   kubectl describe nodes
```

`kubectl logs <pod>`
   * By default if you run it on a multi-container pod, gives you the logs related to the first container in the pod, but you can over-write it with:
      * `--container <containerName>`

### kubectl exec
   * `kubectl exec`
   * two ways:
      1. remote command execution
         * send to container from local shell
         * `kubectl exec <podName> -- <command> `
         * by default they run in the first container in the pod, but can be over-written using `--container` flag
      2. exec session
         * connect local shell to the container's shell
         * `kubectl exec -it <podName> -- sh`
* Edit objects:
   * `kubectl edit <object> <objectName>`

**Deleting objects:**
   * `kubectl delete <object> <objectName>`
   * can also be done using the file, which was used to create the object:
   * `kubectl delete -f <fileName>`

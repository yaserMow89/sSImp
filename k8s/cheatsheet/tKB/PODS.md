PODS - Chapter 4
========================

- see complete list of pods *attributes*
```
kubectl explain pods --recursive
```
   - Can even see specific attributes:
   ```
   kubectl explain pod.spec.restartPolicy
   ```

#### Resource sharing on Pods:
   - Shared fs and volumes (mnt namespace)
   - Shared network stack (net namespace)
   - Shared memory (IPC namespace)
   - Shared process tree (pid namespace)
   - shared hostname (ut namespace)

#### Pods and scheduling
   - All containers in the same Pod are guaranteed to be scheduled in the same cluster node
   - Advanced scheduling features like:
      * nodeSelector
      * Affinity and anti-affinity
         * More powerful node selectors
         * *attract* --> Affinity rules
         * *repel* --> Anti-affinity rules
         * *obeyed* --> Hard rules
         * *suggestions* --> Soft rules
         * An example would be:
```
         A hard node affinity rule specifying the project=qsk label tells the scheduler it can only
         run the Pod on nodes with the project=qsk label. It won’t schedule the Pod if it can’t
         find a node with that label. If it was a soft rule, the scheduler would try to find a node
         with the label, but if it can’t find one, it’ll still schedule it. If it was an anti-affinity rule,
         the scheduler would look for nodes that don’t have the label. The logic works the same
         for Pod-based
```
      * Topology spread constraints
         * For example spreading pods across underlying availability zones for high availability
      * Resource requests


### Steps for Deploying a POD
   1. write the yaml manifest for it
   2. post the manifest to API server
   3. Authentication and Authorization
   4. spec validation
   5. scheduler (node filtering)
      * *pending*
   6. pod assignment
   7. **kubelet** supervision
   8. kubelet download the pod spec and asks the local runtime to start it
   9. kubelet monitors pod status, and reports status changes to the API server
- Pod deployment is atomic
   * starts servicing requests once all it's containers are up and running
- **LifecCycle** for POD
   - *pending phase*
   - *running phase*
      * long-lived pod
   - *succeeded state*
      * short-lived pod

#### Restart Policies
   - k8s can't restart pods, it can definitely restart containers
   - This is always done by the local *kubelet* and governed by the value of the **spec.restartPolicy** which can be any of the following:
      * *Alwasy*
      * *Never*
      * *OnFailure*
      * The above policy is Pod-wide
   * The restart policy depends on the nature of the app:
      * *long-living*
      * *short-living*

### Static pods Vs Controllers
   - 2 ways to deploy pods
      1. Directly via *Pod manifest* (rare)
         * static, and can not:
            * self heal
            * scale
            * roll update
         * Because they are only managed by the **kubelet** on the node they are running, and kubelets are limited to restarting containers on the same node. Also if the node fails, the kubelet fails as well and cannot do anything to help the pod
      2. Indirectly via a *workload resources* and controller (most common)
         * Managed by a high available controller
         * the local *kubelet* can still attempt to restart failed containers, but if the node fails or gets evicted, the controller can restart it on a different node.
### The pod *NETWORK*
   - one pod network for the whole cluster
      * flat layer-2 overlay network (usually)
      * implemented by a third-party plugin
      * configures network via *Container Network Interface (CNI)*
      * The network is only for pods, *not nodes*

### Multi-container pods: Init containers
   * special type, defined in k8s API
   * in the same pod as application containers
      * guaranteed by k8s that they will start and complete before the main app container starts
      * guaranteed by k8s that they will only run once
   * To prepare and initialize the env so it is ready for application containers
```
Example for init container:
Assume you have another application that needs a one-time clone of a remote repository
before starting. Again, instead of bloating and complicating the main application with
the code to clone and prepare the content (knowledge of the remote server address,
certificates, auth, file sync protocol, checksum verifications, etc.), you implement that
in an init container that is guaranteed to complete the task before the main application
container starts.
```
### Multi-container pods: Sidecars
   * A drawback of the *init containers* is that they are limited to running tasks before the main app container app starts, this can be covered by *sidecars* containers
   * regular containers
   * run for the entire lifecycle of the pod
   * it's job is to add functionality to the app, without having to implement it in the actual app
   * For example:
      * logs scrapping sidecars
      * sync remote content
      * broker connections
      * network traffic enc/dec

#### pod hostnames
   * taken from their yaml file's **metadata.name** field
   * If a pod is multi-container all of them will get the same name

#### pod immutability:
   * Two levels:
      1. *Object immutability (the Pod)*
         * taken care of by k8s
      2. *App immutability (the container)*
         * takn care of by user

#### resources requests and resources limits
   * requests --> **Minimum** values
   * limits --> **Maximum** values
   * can be observed using:
      `kubectl get pod <podName> -o yaml`
   * An example:
```
Consider the following snippet from a Pod YAML:
resources:
   requests:
      cpu: 0.5
      memory: 256Mi
   limits:
      cpu: 1.0
      memory: 512Mi
<<==== Minimums for scheduling
<<==== Maximums for kubelet to cap
This container needs a minimum of 256Mi of memory and half a CPU. The scheduler
reads this and assigns it to a node with enough resources. If it can’t find a suitable node,
it marks the Pod as pending, and the cluster autoscaler will attempt to provision a new
cluster node.
Assuming the scheduler finds a suitable node, it assigns the Pod to the node, and the
kubelet downloads the Pod spec and asks the local runtime to start it. As part of the
process, the kubelet reserves the requested CPU and memory, guaranteeing the resources
will be there when needed. It also sets a cap on resource usage based on each container’s
resource limits. In this example, it sets a cap of one CPU and 512Mi of memory. Most
runtimes will also enforce resource limits, but how each runtime implements this can
vary.
```




### *Cloud-Native* applications
   - posses cloud like features such as:
      - auto-scaling
      - self-healing
      - automated updates
      - rollbacks and more

- k8s 1.24 removed support for *Docker* as runtime, since then most k8s clusters ship with *containerd* as the default runtime.
- Container runtime interface (*CRI*)
- Kubernetes originates from the Greek word *helmsman* or the person who steers a ship
- K8s --> the Operating System (*OS*) of the cloud
   - Lets you to *abstract* the underlying infrastructure, the same way an *OS* abstracts the server resources

### k8s principles of operations
- k8s is both:
- Everything related to cluster is in: OneNote --> SeDe --> k8s --> intro
   1. A **cluster**
      - One or more nodes providing resources by applications
      - k8s supports two types of nodes:
         1. Control plane nodes:
            - k8s intelligence
            - At least one is required for every cluster
            - Every control plane node, runs every control plane service
            - Brain of k8s
            - Services that make up the control plane
               1. API Server
                  - All communications take place via the *API* server
                     - A RESTful API over HTTPS
               2. The cluster store
                  - Holds the **Desired state** of all applications and **Cluster Components**
                  - Only stateful part of the control plane
                  - Based on the **etcd** distributed database
                     - Large clusters run a separate *etcd* cluster for better performance
                     - prefers odd number of replicas to help avoid **split brain** conditions
                        - Having a quorum (majority)
               3. Controllers and controller manager
                  - Controllers ensure the cluster runs what you asked it to run
                  - To implement cluster intelligence, some of the common ones include:
                     * A. The Deployment Controller
                     * B. The statefulSet Controller
                     * C. The ReplicaSet Controller
                  - *Controller Manager* --> for spawning and managing the individual controllers
               4. The Scheduler
                  - Watches the API server for new work tasks and assigns them to healthy worker nodes by implementing the following process:
                     * A. Watch the API server for new tasks
                     * B. Identify capable nodes
                        - predicate checks, filtering, ranking algorithm.
                        - Checks for taints, affinity and anit-affinity rules, network port availability, and available CPU and memory.
                        - Ignores incapable nodes and ranks the capable nodes, and assign the tasks to the one with the highest points
                     * C. Assign tasks to nodes
                  - No suitable node: **Pending**
                     - If cluster is configured for **node autoscaling**, the pending node kicks off a cluster auto scaling event that adds a new node and schedules the task to the new node.
               5. The Cloud Controller Manager
                  - Integrates cluster with cloud services
         2. Worker nodes
            - For running user applications
            - Major Components are:
               1. **Kubelet**
                  - Main k8s agent and handles all communication with the cluster
                  - performs following key tasks:
                     * A. Watches the API server for new tasks
                     * B. instructs the appropriate runtime to execute tasks
                     * C. Reports the status of tasks to the API server
                  - If a task won't run reports the problem to the API server and lets the control plane to decide what actions to take.

               2. Runtime
                  - one or more for executing tasks
                  - Usually *containerd* is pre-installed
                  - runtime tasks include:
                     * A. Pulling container images
                     * B. Managing lifecycle operations such as starting and stopping containers
               3. Kube-proxy
                  - Runs on every worker node
                  - implements cluster networking and load balances traffic to tasks running on the node
   2. An **orchestrator**
      - Deploy applications
      - Heal them
      - Scale them
      - Manage zero downtime rolling updates

#### packaging apps for K8S
   1. App is containerized
   2. Apps need to be wrapped in **Pods** to run on
   3. Pods are normally wrapped in higher-level **controllers** for advanced features


### The Declarative model and Desired state
   - Three basic principles:
      - A. Observed state
         - Also referred as: *Actual state* & *current state*
      - B. Desired state
      - C. Reconciliation
   - The **Declarative** model works like this in k8s:
      - Describe *Desired state* in YAML file
         - Images, replicas, network ports, etc..
      - Post to API server
         - Authenticated and Authorized
         - `kubectl` command line utility
      - recorded in the **cluster store** as **record of intent**
      - Controller notices the observed state of the cluster doesn't match the new desired state
      - Controller makes the necessary changes to reconcile the differences
      - Controller runs in the background, making sure the observed state matches the desired state
### Pods and Containers
   - Powerful use cases:
      - Service meshes
      - Helper Services
      - Apps with tightly coupled helper functions
   - *Single Responsibility Principle*

#### pod Anatomy
   - Every pod is a shared execution environment for one or more containers, it includes:
      - network stack
      - volumes
      - shared memory and more

#### pods scheduling
      - Containers in a pod are always scheduled to the same node
      - Starting a pod is an *atomic* operation
         - A pod is running only when all it's containers are running
#### pods as the unit of scaling
#### pods immutability
#### Deployments:
   - Pods are deployed via higher level controllers such as:
      - *deployments*
      - *StatefulSets*
      - *DaemonSets*
   - They add *self-healing*, *scaling*, *rolling updates* and *versioned rollbacks* to *stateless apps*
#### service objects and stable networking
   - k8s *services* provides reliable network for groups of pods
      - It is a k8s API object
      - provides a reliable name and IP
      - load balances
   - Should think of it, as having a *front-end* and a *back-end*
   - List of healthy pods

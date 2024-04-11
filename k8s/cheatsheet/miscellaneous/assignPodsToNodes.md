Assign Pods to Nods
===================
The following content are taken from the following links:
[Assigning Pods to Nodes](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/),
[Assign Pods to Nodes](https://kubernetes.io/docs/tasks/configure-pod-container/assign-pods-nodes/)
- Several ways to do this
- All recommended approaches use **Label Selectors
- Following approaches are available; before going through them you should understand **Node labels** (explained below):
   1. **nodeSelector** against **node labels**
      - Simplest
      - Kubernetes only schedules the onto nodes that have each of the labels you specify
      - Adding a label to a node: `kubectl label node <nodeName> <key>=<value>`
      - Showing labels on nodes: `kubectl get nodes --show-labels`
      - Showing labels on **a** node: `kubectl get node <nodeName> --show-labels`
      - Assining pod to specific node: can be done either using **label** or **name**
         - Using **label**
         ```
         apiVersion: v1
         kind: Pod
         metadata:
            # populate your metadata
         spec:
            containers:
               - image: <imageName>
                 name: <containerName>

            nodeSelector:
               <labelKey>: <labelValue>
         ```
         - Using **name**
         ```
         apiVersion: v1
         kind: Pod
         metadata:
            # Your metadata
         spec:
            nodeName: <nameForTheDesiredNode>
            containers:
               - name: <name>
                 image: <image>

         ```
   2. **Affinity** and **anti-affinity**
      - Expands the type of constraints you can define over **nodeSelector**
      - Some of it's benefits include:
         - more expressive language
            - More control over selection logic
         - A rule can be indicated as **soft** or **preferred**
            - Scheduler will still schedule the pod, even if it can't find a matching node
         - Constrain pods on other pods (allows to define rules for which pods can be co-located on a node)
      - Two type of affinity:
         * A. **Node Affinity**                  
            - Like *nodeSelector*, but with a more expressive syntax
            - Similar to *nodeSelector*
            - Two types of **node affinity**
               - `requiredDuringSchedulingIgnoredDuringExecution`
                  - The scheduler can't schedule the pod unless the rule is met
                  - Like *nodeSelector*, but with a more expressive syntax
               - `preferredDuringSchedulingIgnoredDuringExecution`
                  - The scheduler tries to find a node that meets the rule
                  - If a matching node is not available, still scheduled
               - In both of the above approache the part `IgnoredDuringExecution` means that if the node labels change after pod is scheduled, the pod continues to run
               - **node affinity** can be specified using `.spec.affinity.nodeAffinity` field in **pod** spec
               - For example (For simplicity only the `.spec.affinity.nodeAffinity` is given here):
               ```
               affinity:
                  nodeAffinity:
                     requiredDuringSchedulingIgnoredDuringExecution:
                        nodeSelectorTerms:
                           - matchExpressions:
                              - key: topology.kubernetes.io/zone
                                operator: In
                                values:
                                 - antarctica-east1
                                 - antarctica-west1
                     preferredDuringSchedulingIgnoredDuringExecution:
                     - weight: 1
                       preference:
                        matchExpressions:
                        - key: another-node-label-key
                          operator: In
                          values:
                           - another-node-label-value
               ```
               - The node **must** have a label `topology.kubernetes.io/zone` and the value of that label must be either `antarctica-east1` or `antarctica-west1`
               - The node **preferably** has a label with the key `another-node-label-key` and the vlue `another-node-label-value`
               - `operator` field can be used to specify a logic, it can be: `In`, `NotIn`, `Exists`, `DoesNotExist`, `Gt` and `Lt`
               - *`weight`*
                  - from 1-100 for each instance on the `preferredDuringSchedulingIgnoredDuringExecution` affinity type
                  - For selecting between ndoes with the same score

         * B. **Inter-pod affinity/anit-affinity**
            - Based on labels of pods already running on that node
            - Topology domain like node, rack, cloud provider zone, or region or similar
            - label selectors, with an optional associated list of *namespaces*
   3. **nodeName** field
   4. **Pod topology spread constraints**

##Node labels:
- Manual attachment
- Also populated via k8s with a standard set of labels on all nodes in cluster
###Node isolation/restriction
- Labels on nodes and scheduling pods on them, ensures isolation, security or regulatory properties
- If used for *isolation*, choose labels that can't be modified by `kubelet`

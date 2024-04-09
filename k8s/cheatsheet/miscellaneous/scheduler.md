Kubernetes Scheduler
====================
- The following content are taken from this [link](https://www.youtube.com/watch?v=bbPcb2JuJPw)


### Scheduling
   - Assign a node to a pod
      - makes the bind
   - 2 phases:
      - When scheduling a pod, the scheduler takes all the nodes in the cluster, and passes them through some sets of functions (each of them computed independently) in each phase
      - Any of the functions failure for a specific node, would discard the node (the node will not go through next processing step)
      1. **Predicates** (Filtering)
         - *Features*
            - **Overcommit**
               - Resource requirements of a pod can be met by a node
                  - Scheduler does not care about **resource LIMITS** at all
                  - Subtract all the available resources of the node from the **resource REQUESTS** of a pod, to check if a node can run the pod
               - Which nodes are capable of running the pod at all
                  - Discarding some nodes
            - **pod anti-affinity** (*co-scheduling*)
               - Avoid putting specific pods on same nodes
               ```
               PodAntiAffinity: {
                  TopologyKey: "hostname",                  # Relates to nodes
                  LabelSelector: "labelKey:labelValue"      # Relates to pods
               }
               ```
               - `TopologyKey` --> Grouping nodes
                  - can take these values: `hostname`, `zone` and `region`
               - `LabelSelector` --> Pods identification part
            - **pod affinity** (*co-scheduling*)
               - Put specific pods on same nodes
               - Defined same as *anti-affinity*
               ```
               PodAffinity: {
                  TopologyKey: "hostname",
                  LabelSelector: "labelKey:labelValue"
               }
               ```
               - *Co-location* doesn't mean within the same node, but rather co-location within some group of nodes (can also be node itself, but can also be: *rack*, *zone* or *region*)

            - **Taints** (*Dedicated machines*)
               - Make a set of nodes dedicated (reserve) for a specific set of users
               ```
               Taint: {
                  TaintEffect: "NoSchedule",
                  Key: "color",
                  Value: "blue"
               }

               Toleration: {
                  Key: "color",
                  Value: "blue",
                  Operator: "Equal",
                  TaintEffect: "NodeSchedule"
               }
               ```
                  - The `Operator` can be either `Equal` or `Exists`
                     - `Equal` is default value
                        - Both `Key` and `Value` need to match
                     - `Exists`
                        - Only the `Key` matters, `Value` is not checked
                  - Above says: do not schedule pods, to this node unless they have the specified toleration
         - At this point all the nodes that can run the pod are filtered out, now the *scheduler* is going to select a node to run the pod on, and it falls in the **Priorities** phase:
      2. **Priorities** (Scoring)
         - Scoring the capable nodes
         - How node is selected
            - **Best fit** Vs **Worst fit**
               - **worst fit**
                  - Spread the amount of resources by pods, **as evenly as possible** across the nodes
                  - The more available resources on a node, the better the node is
                     - Calculated ration based
                  - **Default** setting
               - **Best fit**
                  - In scenarios where you want to have as less amount of nodes up as possible the **worst fit** is not good, because it will keep lots of nodes up and running and will incur *extra costs*. Having the least amount of possible nodes up and running would be the better option, and it is where the **Best fit** comes in
                  - Nodes which can handle the pods and are more full than other nodes are selected
                     - Making running nodes full before, starting up new nodes
            - **Selector Spreading**
               - *Lower score* given to a node if the same pods from a single deployment are running on it
               - Why?
                  * a. **Fault Tolerance**
                  * b. **Usage Spike** of the is correlated
         - Some functions that can also define pod's preference (the preference affects the score), they are:
            - **Node Affinity**
               - On which node the pod prefers to run
            - **Pod Affinity**
               - Pod can specify to run on a node with as many possible preferred pods as possible
               - *Co-location* doesn't mean within the same node, but rather co-location within some group of nodes (can also be node itself, but can also be: *rack*, *zone* or *region*)
            - **Pod Anti-Affinity**
               - Opposite of the **Pod Affinity**
         - How to **combine Scores?**
            - Priority function is supposed to **return** an **integer** from *0* to *10*
            - While defining a priority function, a **wave** is also assigned to it, and this wave defines how much weight that specific function should add to the score
               - Can be arbitrary integer
            - Score is the result of score for each function into the *wave* of each function on each node
               - Node with **Highest** score is chosen
                  - More than 1 node with the same highest score
                     - *Semi-randomly* --> A node is chosen
      - **Dangers of depending on Priorities**
         - *Not reliable*
         - *changing waves* or *adding new functions* may result completely different
      - Defining *Wave*
         - 1,10,100,1000,...

      - After above two phases scheduler can pick up the one with the highest score
   - How to *influence* the output:
      - You can dictate the scheduler that which function should it go through in the above two phases (Happens during the *cluster setup*)
      -

- Below content are taken from this [link](https://kubernetes.io/docs/concepts/scheduling-eviction/kube-scheduler/#kube-scheduler)
- **Feasible** nodes (Corresponds to the first phase (**predicates**))
   - Nodes that meet the scheduling requirements for a pod
   - No Feasible node --> *unscheduled* pod
- **Scoring nodes** (Corresponds to the second phase (**priorities**))
- **binding** --> After picking a node from list of *feasible* nodes with the highest *score*, the scheduler notifies the **API Server** about this decision in a process called **binding**

Configure Scheduler Profiles
============================
## Pod Scheduling Stages
- When pods are created the end up in a scheduling **queue**; waiting to be scheduled
   - At this stage pods are lined up by their **priority**
      - For setting up **priority**
         1. You should create a **priority** class
            - It's definition file is:
            ```
            apiVersion: scheduling.k8s.io/v1
            kind: PriorityClass
            metadata:
               name: <name>
            value: <priorityValue>
            globalDefault: <bool>
            description: <description>
            ```
            - Can be used in pod definition file; under `.spec.priorityClassName`
      - Pods with higher priority come to the beginning of the queue
   - Then comes the **Filter** phase
      - *Nodes* that can't run the pod are filtered out
   - Comes **Scoring** phase
      - Scheduler scores each node, with respect to the pod being planned for deploying
   - **Binding** phase, where a pod is bound to the node with the highest score
### Plugins
- All the above steps are preformed by certain **plugins**
   - For example
      - the **queue** plugin is **PrioritySort**
      - **Filtering** is **NodeResourcesFit**, **NodeName**, **NodeUnschedulable**
      - **Scoring** is **NodeResourceFit**, **ImageLocality**
      - **Binding** is **DefaultBinder**
#### Extension points
- What **plugins** go where is defined by *extension points*
- At each *stage* there is an *extension point* which a *plugin* can be plugged to
- The extensions are scattered in the following order:
   - For the *Scheduling Queue* there is *queueSort* plug in
   - For *Filtering*
      - preFilter
      - filter
      - postFilter
   - For *Scoring*
      - preScore
      - Score
      - reserve
   - For *Binding*
      - permit
      - preBind
      - bind
      - postBind

## How to change the Default Behavior
- Different `profiles` for each scheduler config file and attach or detach plugins

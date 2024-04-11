Node Affinity
=============

- Pods are hosted on specific nodes
- Example
```
affinity:
   nodeAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
         nodeSelectorTerms:      # where key and value pairs are specified
            - matchExpressions:
              - key: <givenKey>
                operator: In
                values:
                  - <val1>
                  - <val2>
```
- The `key` and `value` pair are in the form `key` `operator` and `value`
- `operator`:
   - `In` operator ensures that the pod is placed on a node with a `key: <givenKey>` and one of the values in the `values` list
   - `NotIn` ensures that the pod is placed on a node with a `key: <givenKey>` with values distinct from list of the given values
   - `Exists` Checks if a label exists on the node, no need for value
## Node affinity type
   - Two states in the lifecycle of a pod, considering node affinity
      1. `DuringScheduling`
         - Does not exist, created for the first time
      2. `DuringExecution`
         - Pod is running
   - Two types of affinity rules (available as of now):
      1. `requiredDuringSchedulingIgnoredDuringExecution`
         - Mandated with the given affinity rules
         - No nodes found, pod will not be scheduled
      2. `preferredDuringSchedulingIgnoredDuringExecution`
         - No matching node, the affinity rule will be ignored
         - place on any available node

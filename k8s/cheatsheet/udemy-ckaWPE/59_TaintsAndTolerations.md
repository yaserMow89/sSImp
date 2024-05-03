Taints and Tolerations
======================
- For a match two things are required
   1. The **taint** on the nodes
   2. The **toleration** on the pods
- Used only for imposing scheduling restrictions
- Very simple, you taint a node, and only pods tolerant to that specific taint can be placed on it
- Taints and Tolerations only tells the node to accept pods with certain tolerations
- **MasterNode** has a taint by default, in order to prevent any pods from being scheduled on it
- `NoExecute` taint is applied before any other taints
- Not more than one taint with the same effect can be created on a node

## Useful commands
- To taint a node `kubectl taint nodes <nodeName> <key>=<val>:effect`
   - `effect` defines what happens to pods that do not tolerate this taint
      - `NoSchedule` --> no new pods
      - `PreferNoSchedule` --> try to behave like `NoSchedule`
      - `NoExecute` --> No new pods, and existed will be evicted if they do not tolerate the taint
- To remove taint `kubectl taint nodes <nodeName> <key>=<val>:effect-`

- To add toleration, in the `spec` section of the pod
```
tolerations:
   - key: "key"
     operator: "Exists" or "Equals"
     effect: "NoSchedule", "PreferNoSchedule" or "NoExecute"
     value: "keyVal"
```

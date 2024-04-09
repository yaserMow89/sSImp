Taints and Tolerations
======================

Following content are taken from this [link](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/)
- In this scenario the **Pod** is the one who makes the final decision, not the **node**
## Taints
- *رنگی کردن*
- To *mark* a node
- Applied to **nodes**
- Allow a node to **repel** a set of pods
- Taint can be added like this:
```
kubectl taint nodes <nodeName> <key1>=<value1>:effect
```
   - *effect* can be either *`NoSchedule`*, *`PreferNoSchedule`* and *`NoExecuse`* --> Explained briefly in next section (*Tolerations*)
- An example would be: `kubectl taint node node1 myKey=keyVal:NoSchedule`
   - `node1` is tainted with a key of `myKey`, value of `keyVal` and effect of `NoSchedule`
- To remove the taint
```
kubectl taint nodes <nodeName> <key1>=<value1>:effect-
```
- For example to remove the taint in the previous example: `kubectl taint nodes node1 myKey=keyVal:NoSchedule-`

## Tolerations
- Applied to **pods**
- Schedule pods with matching taints
- Not guaranteed
- The following example, is in continuation of the previous section's (Taints) example
- To add toleration to a node, in the *`spec`* section we add it like this:
```
tolerations:
   - key: <keyName>
     operator: <operatorType>
     effect: <effect>
     value: <keyVal>
```
- For example, to create a *toleration* to *match* the taint in the previous section:
```
# Taint from previous section is:
kubectl taint node node1 myKey=keyVal:NoSchedule
# Toleration is:
tolerations:
   - key: "myKey"
     value: "keyVal"
     effect: "NoSchedule"
     operator: "Equal"
# Could be done also with this:
tolerations:
   - key: "myKey"
     operator: "Exists"
     effect: "NoSchedule"
```
- The default value for *`operator`* is *Equal*
- Here is how a toleration **matches** a taint:
   - A toleration matches a taint if the `keys` are the **same** and the `efects` are the **same**, and:
      - The `operator` is `Exists` (in which case no `value` should be specified), or
      - The `operator` is `Equal` and the **values** should be equal
   - Two **special cases**
      1. An empty `key` with operator `Exists` matches all keys, values and effects which means this will tolerate **everything**
      2. An empty `effect` matches all effects with key `key1`
- `effect` fields:
   - As mentioned earlier, it can have one of the three following values:
      1. `NoExecute`
         - Affects pods that are already **running** on a node as follows:
            - Pods that do not tolerate the node are **evicted immediately**
            - Pods that tolerate the taint without specifying `tolerationSeconds` in their toleration specification remain bound forever
            - pods that tolerate the taint with a specified `tolerationSeconds` remain bound for the specified amount of time. After that time elapses, the node lifecycle controller evicts the pods from the node
      2. `NoSchedule`
         - No new pods, unless the have a matching toleration. Pods currently running are not evicted
      3. `PreferNoSchedule`
         - *Soft* Version of `NoSchedule` or a preference
         - The control plane will try to avoid placing a pod that does not tolerate the taint on the node, but it is not guaranteed

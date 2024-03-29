Replication Controller
======================
- Multiple instances
- HA
- Desired number of pods are running at a single time
- LoadBalancing & Scaling
- **Replication Controller** Vs **Replica Set**
   * Both have the same purpose, but they ain't the same thing
   * *Replica Controller* is being replaced by *Replica set*
   * *Replica Set* --> new recommended way to manage replicas
- Below is an example of creating a **ReplicationController**
```
apiVersion: v1 # is v1
kind: ReplicationController # is ReplicationController
metadata: # Whatever you want ;)
spec: # what is inside the object we are creating
   template: # Pod template to be used by the ReplicationController to create replicas of it
             # Easily you could bring everything that you have in a pod file her, apart from the apiVersion and the kind field
             # The var type is also dict here
   replicas: # The number of required replicas
```
- Pods created by a specific ReplicationController, their names start with the name of the ReplicationController
- ReplicationControllers can also be seen, using the command: `kubectl get replicationcontrollers`
- Below is an example of creating a **replicaSet**

```
apiVersion: apps/v1 # The apiVersion for replicaSet is different
kind: ReplicaSet
metadata: # Whatever you want ;)
spec: # Similar to the ReplicationController, but only you have a selector key
   template: # Same as ReplicationController
   replicas: # Same as ReplicationController
   selector: # what pods fall under it
             # You have already given the template for the pods in the template section, why would you
             bother again with saying it here?
             # It is because  ReplicaSet can manage pods, that were not created with it's creation process
             # Selector key is one of the major differences between the ReplicationController and the ReplicaSet
             # It is also available in the ReplicationController, if you skip it it assumes the default which is in the template key
```
```
   selector:
      matchLabels:
         <labelKey>: <labelValue>
```

- ReplicaSets can also be seen, using the command: `kubectl get replicaset`
- In the scenarios where you may have hundreds of pods, *labels* and *selectors* are going to prove very useful, for managing the replicas of applications

- How to **Scale**
   1. Update the number of replicas in the definition file and apply it using `kubectl replace -f <definitionFileName>.yml`
   2. Using Command Line itself `kubectl scale --replicas=<desireNumberOfReplicas> -f <originalDefinitionFileName>.yml`
   3. Using the replicaset itself `kubect scale --replicas=6 <objectType> <objectName>`
      - `<objectType>` in our case would be `replicaset`
      - `<objectName>` in our case would be `replicaset's name`
   4. A *replicaSet* can also be simply deleted, using the following command; know that it will also delete the PODs with it; `kubect delete replicaset <nameOfTheReplicaSet>`
   5. Edit the replicaSet on the go: `kubect edit replicaset <nameOfTheReplicaSet>` and then delete the pods, to recreate new ones

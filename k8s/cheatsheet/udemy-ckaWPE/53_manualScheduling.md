Manual Scheduling
=================
- while defining a pod, there is a by default hidden field, name `nodeName: `
   - Only nodes with undefined value for this key (`nodeName`) are considered for scheduling the pod
   - Once a node is selected for the pod, the property `nodeName` value is set to the name of the node
   - This is done by creating a **binding** object

- **No Scheduler**
   - The pods will go in **pending** state
   - You can assign nodes *manually* by yourself
   - The simplest way to preform manual scheduling, in the absence of a scheduler is to set the `nodeName` field to the name of the node, in the pod definition file while creating it
   - Above is only possible while pods creation, once the pod is created and is in pending state you can't do this; K8S also doesn't allow to modify the `nodeName`  property of a pod; the other way to assign a node to an existing pod, is to create a **binding object** (Mimicking actually what scheduler does)
   ```
   apiVersion: v1
   kind: Binding
   metadata:
      name: <bindingName>
   target:
      apiVersion: v1
      kind: Node
      name: <nodeName>
   ```
   - Send a POST request to the pods binding object, with the data in the `json` format
      ```
      curl --header "Content-Type:application/json" --request POST --data '{"apiVersion":"v1", "kind":"Binding", ...}' http://$SERVER/api/v1/namespaces/default/pods/$PODNAME/binding
      ```

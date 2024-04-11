Daemon Sets
===========

- All or some nodes run a copy of a pod
- A new node --> pods added to it
- Remove a node --> Garbage collected nodes
- Deleting a *DaemonSet* --> clean up the pods created by it
- Some typical use cases of *DaemonSet*
   - cluster *storage* daemon on every node
   - *logs* collection daemon on every node
   - *node* monitoring daemon on every node

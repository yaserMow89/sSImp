Kube Scheduler component
========================

- Which pod goes on which node
- Doesn't actually place it on the node
- placing pods on the nodes is the job of `kubelet`
- Scheduling depends on certain criteria
   * Resource requirements in the pods
   * Nodes dedicated to certain applications
- Tries to find the best node for each pod
- Two phases of identifying best node for the pod:
   1. **Filter** nodes that do not fit the profile for this pod
   2. **Rank** nodes:
      - Priority function to rank on scale of **0-10**
         - For example calculating the amount of resources on the node that is going to be free after the pod is placed on that node
            - The one with higher amount of resources left, gets higher score and wins
- If you want to see the options available with **kube-scheduler**:
   - **kubeadm**: in this way you can find it on the master nodes kubernetes config directory, which is: `/etc/kubernetes/manifests/kube-scheduler.yaml`
   - You can also locate it's running process and spectate the passed options

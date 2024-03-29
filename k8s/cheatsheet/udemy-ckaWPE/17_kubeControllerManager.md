Kube Controller Manager
======================
- Manages various controllers in k8s
- continuously watching the status
- takes various actions to remediate situation
- A **controller** is a process that continuously monitors the state of various components withing the system, and works towards bringing the whole system to the **desired** functioning state
1. **Node Controller**: controls the state of the nodes, and takes actions to keep the application running
   - Achieves this through the *kube-apiserver*
   - Every **5 seconds**
   - stops receiving heartbeats from a node --> **Unreachable**
      - Waits for **40 seconds** before marking **unreachable**
      - Once a node is marked **unreachable** it gives it **5 minutes** to come back, if not it'll remove the pods assign to that specific node and provisions them to healthy nodes, if the pods are part a *replicaSet*
2. **Replication-Controller**: Ensuring the **desired** number of pods are available at all time within the set
   - If one dies another one is created

- Whatever services and intelligence is on k8s, it is implemented through these controllers, like:
3. **Deployment-Controller**
4. **Namespace-Controller**
5. **Endpoint-Controller**
- etc..

### kube-controller-manager
   - Packs all the various controllers on the k8s in a single process
   - can be downloaded and installed as a service
   - In a `kubeadm` provisioned environment all the options for the **controller-manager** can be found at the same place as other components of the control plane: `/etc/kubernetes/manifests/kube-controller-manager.yaml`
      - One of the intersting options would be `--controllers`, it is to define all the controller nodes of yours
         - In case any of them doesn't work, this is a good place to remove it from and put it back once it comes back
   - In a non `kubeadm` provisioned env, the configuration and options can be seen at the service location of the **kube-controller-manager** as other components, which is: `/etc/systemd/system/kube-controller-manager.service`
   - Can also be seen using looking at the **running processes** and it's effective options

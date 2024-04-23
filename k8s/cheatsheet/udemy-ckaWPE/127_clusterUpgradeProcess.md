Cluster Upgrade Process
=======================
 - K8S components does not have be in the same version
 - None of the components should be at a higher version that the **kube-apiserver**, since it is the primary component in the *control-plane* and all components talk to each other through this
 - **controller-manager** and **kube-scheduler** can be at *one version lower*
- **kubelet** and **kube-proxy** can be at *two versions lower*
- **kubectl** can be *one higher or one lower*
- This is in order to be able to carry out live upgrades
- At any time k8s only **supports** last *three minor* versions

- HOW TO DO UPGRADES?
   - *One Minor* version at a time

## How to upgrade cluster setup by *`kubeadm`*
- 2 major steps
   1. **Master Nodes**
      - While upgrading the control-plane components go down briefly
         - But all workloads on the worker-nodes continue to serve users as normal
         - Only *management* functions go down
         - No access using `kubectl` or other k8s api
         - Can't deploy new application or delete or modify existing ones
         - *controller-manager* is not working also
            - So if a pod fails, no replacement pods will be scheduled

   2. **Worker Nodes**
      - Several strategies to upgrade them
         - **All at once**
            - All pods are down, downtime, users not able to access applications
         - **one at a time**
         - **Add new nodes**
            - Node with newer software version
            - Especially good if you are on a cloud environment
               - Can commission and decommission easily

### In practice
   - Using `kubeadm`
      - `kubeadm upgrade plan`
         - Gives you good information
            - *Current* cluster version
            - *kubeadm tool* version
            - *latest stable* version
            - *control-plane* components and their versions and available versions
            - Once the upgrade is done, you must manually upgrade `kubelet` on each node
            - *cluster* upgrade command
            - *kubeadm* upgrade command
      - Upgrade steps:
         - **Master** nodes
            1. Upgrade `kubeadm` itself, as it was suggested in `kubeadm upgrade plan`
               - `apt-get upgrade -y kubeadm=<desiredVersion>`
            2. Upgrade *cluster* using command was suggested in `kubeadm upgrade plan`
               - `kubeadm upgrade apply <desiredVersion>`
               - After this your *control-plane* components are upgraded to the `desiredVersion`
            3. If you have `kubelet` on master nodes, you should also upgrade it on them, can be done using
               - `apt upgrade -y kubelet=<desiredVersion>`
               - After upgrade restart the kubelet service
                  - `systemctl restart kubelet`
         - **Worker** nodes
            - NOTE: on the video he also upgrades the `kubeadm` on each node using `sudo kubeadm upgrade node` command
            1. Move the **workloads** from the node under upgrade to other nodes
               - `k drain <desiredNode>`
                  - *reschedule* workload on other nodes
                  - Marks the node as *un-schedulable*
            2. Upgrade the `kubeadm`
               - `apt upgrade -y kubeadm=<desiredVersion>`
            3. Upgrade the `kubelet`
               - `apt upgrade -y kubelet=<desiredVersion>`
            4. Upgrade node configuration for the new `kubelet` version
               - `kubeadm upgrade node config --kubelet-version <newKubeletVersion>`
            5. Restart the `kubelet` service
               - `systemctl restart kubelet`
            6. `uncordon` the node
               - `k uncordon <desiredNode>`
            7. Preform the same steps with other nodes


#### Useful points
- Pay attention to package repositories
   - For each minor version there is a different package repository, which should be added to the repos on your system and sign it
- Before starting the upgrade do a cache update `apt get update`
- You can see the **upgradeable** versions using `apt-cache madison kubeadm`
- The `VERSION` column in `k get nodes` is referring to `kubelet`

CNI in Kubernetes
=================
- Defines the responsibilities of container runtime
- The responsibilities are:
   1. Create network namespaces
   2. Identify network the container must attach to
   3. Invoke network plugin when Container is ADDed
   4. Invoke network plugin when container is DELeted
   5. JSON format of the network configuration
- CNI plugin is configured in the `kubelet` service
   - Looking at `kubelet.service` file, you will find the options:
      ```
      --network-plugin=<plugin> \\
      --cni-bin-dir=/opt/cni/bin \\
      --cin-conf-dir=/etc/cni/net.d   
      ```
   - Can also be seen by looking at running processes
      - `ps -aux | grep kubelet`


## Useful commands for `CNI`
- `/etc/cni/net.d/` --> you can find the `CNI` which is being used here

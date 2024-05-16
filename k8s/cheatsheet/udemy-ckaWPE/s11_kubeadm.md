Installing Kubernetes Cluster using `kubeadm`
=============================================

## Steps:
1. VMs or Physical machines
2. Designating *Master* and *worker* nodes
3. Install *container-runtime* on the nodes (`containerd` in our case)
4. Install `kubeadm` to bootstrap the k8s
5. Initializing the *master* server
6. Ensuring Network prerequisites are met (**Pod** network)
7. Join worker nodes to the master nodes


## Acting
1. All set
2. All set
3. Container-runtime
   - Enable ipv4 forwarding
   ```
   # sysctl params required by setup, params persist across reboots
   cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
   net.ipv4.ip_forward = 1
   EOF

   # Apply sysctl params without reboot
   sudo sysctl --system
   ```
      - Can be verified using `sysctl net.ipv4.ip_forward`
   - Install `containerd` --> follow the instructions with the links
      - You don't want to install all the packages for `docker` only `containerd`
      - Can be verified `systemctl status containerd`
   - *Crgroup drivers*
      - Two available --> `cgroupfs` and `systemd`
      - In case you are using a `systemd` init system, you should use the `systemd` Cgroup drivers
         - To know your **init**, just look for it's process `ps -p 1`
      - Should be changed because `cgroupfs` is the default for container-runtime
      - The driver should be the same between `kubelet` and `container-runtime`
      - Follow the instruction at *configuring the systemd cgroup driver* to configure `systemd` as cgroup driver
4. Installing `kubeadm`, `kubelet` and `kubectl`
   - Again some copy paste job
5. Initialization
   - Use the link at the bottom of the page to get to the next steps
      - Go to **Initializing your control-plane node**
      - Only on the master node
      - Don't delete the output you get after initializing the cluster, and follow the steps given to you
         - Make sure the `ipalloc-range` of the network solution matches the `--pod-network-cidr`
            - You can edit the network solution daemon set for this
               - Add an environment variable
               ```
               - name: IPALLOC_RANGE
                 value: <--pod-network-cidrValue>
               ```
                  - Make sure it is on the right container inside the daemonset
                     - Container name is `weave` in weave example
7. Join worker nodes to the master using the given command on the master node


```
kubeadm join 172.31.114.77:6443 --token rl0aqi.lf8us1rzleotc0fd \
	--discovery-token-ca-cert-hash sha256:323e8c11d56afe98e91dbd742f4a39f5dcf01f8b4beae5d63735e1b87aa08ccc 
```

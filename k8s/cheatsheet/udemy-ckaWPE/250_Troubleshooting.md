Troubleshooting
===============


Application Failure
===================
- Checking All the links in the chain to find the root cause of the issue
- Use `curl` to see if the service or application responds back
- Checking **Services** for the discovered **endpoints** with pods
- Comparing the **Selectors** configured on the pods to the **Services**
- Making sure the pod is in a **running** state
- **Status** of the pod and *Number of Restarts*
- Why the pods **failed** last time
   - Should either watch **logs** using `-f`
   ```
   k logs <podName> -f
   ```
   - Or use the `--previous` option to view logs from previous pods
   ```
   k logs <podName> -f --previous
   ```
- Check status of other **services** (If you have any), for example a *db*
- Check other pods which are working together with the concerned application


Control plane Failure
=====================
- Checking status of the nodes and see if the are *healthy* (`Ready`)
- Check the status of the pods running on the cluster
- If the cluster is deployed using `kubeadm` check for the pods in `kube-system` namespace
- Looking for the logs of control plane components
- Or if they are deployed as **services**, check the status of the **services**
   - On master nodes
   ```
   service kube-apiserver status
   service kube-controller-manager status
   service kube-scheduler status
   ```
   - On worker nodes
   ```
   service kubelet status
   service kube-proxy status
   ```
- Looking at service logs
   - Using `journalctl`


Worker Node Failure
===================
- Checking the **status** of the nodes (`Ready` and *healthy*)
- If not ready, check the details about the node
```
k describe node <nodeName>
```
   - Check for the `status` of `conditions.type`
   - If the statuses are set to `Uknown` is because a worker node has stopped communicating with the master node
      - Can indicate a possible loss of a node
      - Check the `LastHeartbeatTime` to know when it might had crashed
   - Check the node itself
      - Check the `kubelet` status
         - Check it's *logs*
         - Check the `kubelet` certificates
            - Make sure they are **not expired**
            - Part of the right **group**
            - Issued by the right **CA**

Network Troubleshooting
=======================

## DNS
- Memory is affected by the number of Pods ans Services in the cluster
- Kubernetes **resources** for **coredns** are
   - SA --> `coredns`
   - cluster roles --> `coredns` and `kube-dns`
   - clusterrolebindings --> `coredns` and `kube-dns`
   - deployment --> `coredns`
   - configmap --> `coredns`
   - SVC --> `kube-dns`
- While analyzing the coreDNS deployment you can see that the the Corefile plugin consists of important configuration which is defined as a configmap
- port 53 is used:
```
kubernetes cluster.local in-addr.arpa ip6.arpa {
   pods insecure
   fallthrough in-addr.arpa ip6.arpa
   ttl 30
}
```
- Above is the backend to k8s for cluster.local and reverse domains.

- `proxy . /etc/resolv.conf`
   - Forward out of cluster domains directly to right authoritative DNS server.

### coreDNS
- If *coreDNS* pods are in `pending` state check for `network plugin` to be installed

- **CrashLoopBackOff** or **Error State**
   - `SElinux` with an older version of *docker*
   - You should try one of the following to solve the issue
      1. Upgrade *docker*
      2. Disable `SElinux`
      3. Modify *coreDNS* deployment to set `allowPrivilegeEscalation` to true
      ```
      allowPrivilegeEscalation: true
      ```
      4. Loops result in *coreDNS* pod to have `CrashLoopBackOff`
         - To resolve
         - Add the following to the `kubelet` config `yaml` file
            ```
            resolvConf: <pathToRealResolvConfFile>
            ```
               - This flag tells `kubelet` to pass an alternate `resolv.conf` to pods
               - For systems using `systemd-resolved`, `/run/systemd/resolve/resolv.conf` is typically the location of the *real* `resolv.conf` although this can be different
         - Disable local dns cache on host nodes and restore the `/etc/resolv.conf` to the original
         - A quick fix is to edit your **Corefile**, replacing forward `/etc/resolv.conf` with the IP address of your upstream DNS for example `8.8.8.8`
            - But this only fixes the issue for *coreDNS*, `kubelet` will continue to forward the invalid `resolv.conf` to all default *dnsPolicy* pods, leaving them unable to resolve DNS

### kube-proxy
- A network proxy that runs on each node
   - Maintains network rules on nodes
   - Responsible for watching **services** and **endpoint** associated with the service
      - When the client connects to the service using the *virtualIP* the **kubeProxy** is responsible for sending traffic to actual pods
- If a cluster is configured using `kubeadm` it is available as a **daemonSet**
- The binary within the daemonset runs with the following command inside *kube-proxy* container
   ```
   command:
      /usr/local/bin/kube-proxy
      --config=/var/lib/kube-proxy/config.conf
      --hostname-override=$(NODE_NAME)
   ```
   - Fetches the configuration from a configuration file `/var/lib/kube-proxy/config.cong`
      - In the `config` file we define:
         - `clusterCID`
         - `kubeproxy mode`
         - `ipvs`
         - `iptables`
         - `binaddress`
         - `kube-config`
         - etc
   - We can override the **hostname** with the node name of at which the pod is running

- Kube-proxy **Troubleshooting**
   - make sure it's pod is running in `kube-system` namespace
   - Check logs related to it
   - Check *configMap* is correctly defined and the config file for running `kube-proxy` binary is correct
   - `kube-config` is defined in the `config map`
   - check `kube-proxy` is running inside the container

Service Networking
==================


- Pods are configured rarely to communicate with each other
   - Usually it happens by implementing services
- When a *Service* is created it is accessible from all pods across the cluster, irrespective of the node on which they reside
   - *services* are **cluster-wide** resources
- Services are only virtual objects

- **ClusterIP**
   - Only accessible from within the cluster
- **NodePort**
   - Accessible from outside the cluster
      - Can be accessed from outside the cluster using the *exposed* node port
      - Can be accessed from withing the cluster using it's ip

- How all of the above happens
   - When a service is created, it is assigned an *ip address* from a pre-defined range
      - The `kube-proxy` agents get the ip and make forwarding rules on each node across the entire cluster (Not only IP, but also the a port)
         - Saying any traffic coming to this IP, should go to the IP of the *pod*
   - How are these rules created?
      - `kube-prox` supports different ways to implement this
         - `userspace`
         - `ipvs`
         - `iptables` --> default mode
      - `proxy-mode` can be set while setting up the `kube-proxy` service
         - `kube-proxy --proxy-mode [userspace | iptables | ipvs ] ...`
            - If not set, defaults to `iptables`
      - The `ClusterIP` service `ip` range is available in the `/etc/kubernetes/manifests/kube-apiserver.yaml` file, under the option `--service-cluster-ip-range=<ipRange>`
         - The *default range* is `10.0.0.0/24`
   - The rules created by `kube-proxy` can be seen in the `iptables` *NAT* table output
      - Search for the name of the service as all rules created by `kube-proxy` have a comment with the name of the service on it
      - `iptables -L -t nat | grep <serviceName>`
   - All the above can also be seen in the `logs` (`/var/log/kube-proxy.log`)
      - The location fo the log file, depends on the installation

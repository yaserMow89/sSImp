Cluster Networking
==================


- Master and worker nodes
- At least one interface connected to a network
- An address on each interface
- Unique **Hostname** set
- Unique MAC address
- Some **Ports** needed to be open
   - `kube-api` on master
      - Accepts on port 6443
   - `kubelet` on all nodes
      - Leverage port 10250
   - `kube-scheduler`
      - Listens on port 10259
   - `kube-controller-manager`
      - Listens on port 10257
   - `nodePort` service on worker nodes
      - 30000 to 32767
   - `ETCD` server
      - Listens on port 2379
      - If more than one master nodes:
         - `ETCD` clients need port 2380 also to communicate with each other


## Some Useful commands
- `ip address show type <ifType>` --> show interface of specific type
- `ip route` --> show routing table
- `netstat -tulpn` is very useful ;)
   - `netstat -npa` --> shows all socket

High Availability
=================

## Kubeconf Youtube Video:
- Multi **Master** or **control** nodes
   - Great, but not enough
- what about *Networking*, *Applications*, *Persistence*
- No single points of **Failure**
- What sort of **Failures**
   - Application --> multiple copies
   - VM --> if all applications running on the same VM
   - Physical machines --> if all VMs are on the same Physical machine
   - Electric & Power --> if all physical machines are connected to the same power source
   - Network partition --> if one switch fails
   - Storage --> if fails we don't lose data

#### Regions and Zones:
   - **Regions** --> geographical areas, very isolated, can handle natural disasters across areas
   - **Zones** --> Deployment areas within a **region**, independent in a lot of ways:
      - power sources
      - cooling systems
      - etc..

### High Availability in *GKE*
   1. Application HA
      - **Zones**: Scatter the VMs across Zones
      - **ReplicaSet**
      - **RollingUpdate** strategy
      - **Setting Zones** --> Study more
      - **Node Upgrades**: **PodDistruptionBudget** --> Study more
   2. Control Plane HA
      - **Zones**: Scatter the Control plane across different zones
         - If the zone in which Control plane is running goes down, the control plane also goes down, but the deployments in other zones are healthy and will continue to operate
            - In this case you can still use a LoadBalancer to avoid sending traffic to the containers which were residing in the same zone as the control plane and they went down also
         - For creating replicas of the **control plane**, we should take into account of how it's components are going to be replicated
            * *api-server*:
               * It is stateless and is pretty easy to replicate
               * A LoadBalancer is required in front of the api-servers to distribute the traffic to them, and that should be fine
            * **Scheduler** & **Controller Manager**:
               * Cause the fact that they have to read data, act on the data and write data
                  * Due to the above reasons we should make sure that we are running only one instance of each actively at a time
                  * They have a **Locking System** with them
                     * All will attempt to acquire the lock, but one would eventually get the lock and that would become the active one, the others will wait for it to fail, so that they can acquire the lock
      - **Managing** control plane:
         - For example how to do upgrades without downtime?
         - What happens if one of the control plane replicas fail, who/what would keep track of it to bring another replica instead of it
         - who/what would check the Health for the control plane replicas
   3. Data Plane (*Etcd*) HA
      - **Replications** : Strict Majority for Electing a Leader
         - N/2+1 --> at least 51% of the members
         - Odd numbers are better
         - More depends on the user, when it comes to the question of how many replicas is good
      - **Backup** & **Restore**
--------------------------------------------------
## K8S docs:
- The link for the is:[link](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/ha-topology/)
### Creating Highly Available Clusters with `kubeadm`
- In the following HA is meant in the context of **etcd** database
- Two options for configuring the **topology** of your highly available kubernetes clusters
- An HA cluster can be set up using:  
1. **Stacked control plane nodes** or **etcd**
   - *etcd* nodes are colocated with control plane nodes
   - A local *etcd* member in each control plane node
      - This *etcd* member communicates only with the local `kube-apiserver`; by local we mean the server on the node which the *etcd* is located on
      - The same procedure applies to `kube-controller-manager` & `kube-scheduler` instance
   - This strategy **couples** the control planes and *etcd* on the same nodes.
      - Simpler to setup and manage compared to **External etcd**
   - Risk of **Failed Coupling**
      - If one node goes down, both the *etcd* and the control plane instance is down, and redundancy is compromised
         - Can be mitigated by adding more control plane nodes
      - A minimum of **3** stacked control plane nodes for an HA cluster
   - By default a local *etcd* is created on control plane nodes, when using `kubeadm init` and `kube join --control-plane`

2. **External etcd**
   - *etcd* runs on separate nodes from the control plane
   - *etcd* is external to the cluster formed by the nodes that run control plane components
   - *etcd* members run on sseparate host and each *etcd* host communicates with the `kube-apiserver` of each control plane node
   - **Decoupled** controle plane and *etcd* member
      - Losing and *etcd* member or control plane node has less impact and does not affect the cluster redundancy as much as the stacked HA topology
      - And **Twice** the number of **hosts** are required to implement this topology

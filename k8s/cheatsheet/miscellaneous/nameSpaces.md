Explanations on namespaces - From KodeKloud youtube video
==========================

- Create separation between containers and the underlying host
   * containers can't see what is happening in the host space, but the host can see what is happening in the containers space
      * For example if you have a specific process running inside a container, you can see the same process from the host also, but with a different *PID*
- A network namespace can be created using the command `ip netns add <name>`
   * can be seen using the command `ip netns`
- The command `ip link` can be used to see the network interfaces on the host, and the same command can be used to see the interfaces inside a specific **namespace**, can be done in two ways:
   * `ip netns exec <namespaceName> ip link` or `ip -n <namespaceName> link`
      * Running either of the above commands you can't see any of the host's interfaces, because you are running the command from within a namespace and it is *isolated* from the host space.
   * Same can happen for *routing table* and *ARP table* also
      * For ARP on host `arp`
         * on namespace `ip netns exec <namespaceName> arp`
      * For routing table on host `route`
         * on namespace `ip netns exec <namespaceName> route`
- The namespaces can be connected to each other, using a pipe connection, follow steps to do so:
   1. Create a pip `ip link add veth-<nameForOneEnd> type veth peer name veth-<nameForOtherEnd>`
   2. Attach each end to coressponding namespace:
```
ip link set veth-<nameForOneEnd> netns <namespaceName>
ip link set veth-<nameForOtherEnd> netns <namespaceName>
```
      * Once the ends are attached they are visible inside the namespaces also
   3. Assign ips to each end using the command: `ip -n <namespaceName> addr add <ip> dev veth-<nameForOneEnd>`
      * Above command should also run for the other end
   4. bring both ends up using the command `ip -n <namespaceName> link set veth-<nameForOneEnd> up`
      * Above command should also run for the other end
   5. Trying a ping from one namespace to the other one using command: `ip netns exec red ping <IpOnTheOtherSide>`
      * Once pinged, you can check the arp table again, and you should be able to see the neighbor is identified, and vice versa
- **How to achieve the same functionality with lots of namespaces?**
   1. Create a virtual switch `ip link add <bridgeName> type bridge`
      * It is a simple interface which can be seen as any other interface inside the host
   2. The switch is off by default, you should bring it up `ip link set dev <bridgeName> up`
   3. Now the only thing remaining is to connect the nameSpaces to this switch
      * For this it is better to delete the already created link, and for deleting the link you just need to delete it on one end and the other end gets deleted automatically `ip -n <nameSpaces> link del veth-<nameForOneEnd>`
   4. Now create another pipe (cable) to connect the namespace to the switch `ip link add veth-<nameForOneEnd> type veth peer name <veth-<nameForOneEnd>-<br> # br stands for bridge, you can change to whatever you like`
      * can also do the same thing for other namesapces
   5. Connect the two ends to the namespace and bridge using following commands
```
ip link set veth-<nameForOneEnd> netns <nameSpaces> # connection to the namespace
ip link set veth-<nameForOneEnd-<br> master v-net-0 # Connection to the switch
```
      * Repeat the same thing for every namesapce
   6. Now set up ip addresses for the links on the namespaces' ends `ip -n <nameSpaces> addr add <ip> dev veth-<nameForOneEnd>`
      * Follow this for every interface inside the nameSpaces you've got
   7. Bring the interfaces up `ip -n <nameSpaces> link set veth-<nameForOneEnd> up`
      * Follow this for all the interfaces within the namespaces
- **How to establish connectivity between the host and the nameSpaces interfaces**
   By default you won't be able to reach the nameSpaces networks from within your host network, but you can make it possible since the bridge (switch) has one interface on the host and all we need to do is to assign an ip to it so that we can reach the nameSpaces through it. `ip addr add <IPInTheSameRangeAsTheIPsAssignedToTheNameSpaces>/<CIDR> dev <switchInterfaceNameOnTheHost>`
- **Connectivity between the Swithcs network and the outside world**
   * Remember that the switch and all the interfaces attached to it are only reachable among themselves and the host only, and they can't access the external network nor the external networks can reach it.
   * Since the network interfaces within the nameSpaces only know their own network, and they also have no routing information (table) for reaching other networks, you will get `Network is Unreachable` error trying to ping outside world.  
   * You can route all the network in each namespace through the attached port from the host on the bridge
```
ip netns exec <nameSpace> ip route add <IPRangeReachableToHost&YouWantToReachFromWithinTheNameSpace> via <IPForHost'sInterfaceOnTheSwitch>
```
   * Now trying to ping the same IP as eariler, you will not get any responses back (maybe time out; it is my guess)
   * To solve this issue we can Use a NAT; just NAT all the traffic going out from our switch network:
```
iptables -t nat -A POSTROUTING -s <IPRangeForTheSwitch> -j MASQUERADE
```
   * Trying to ping the older address, we should be able to ping it by now.
   **If you would like your nameSpace network to reach everything that your host is able to reach, you can setup a default route on the corresponding nameSpace**
```
ip netns exec <NameSpace> ip route add default via <Host'sIPOnTheSwitch>
```
### Namespaces in k8s
   - You can see all the available nameSpaces in your cluster, using: `kubectl get namespace`
   - Four default nameSpaces:
      1. *kube-system*: For the objects created by the k8s systems
      2. *kube-public*: Mostly reserved for cluster usage, for resources that should be visibl and readable through-out the whole cluster
      3. *kube-node-lease*: For the lease objects associated with each node
      4. *default*: For objects with no other nameSpaces
   - Can see more details on each of them using `kubectl describe namespace <NameOfTheNameSpace>`
      * Two things that you see are:
         * *resource quota*: tracks and aggregates usage of resources in the nameSpace and allows cluster operators to define hard resource usage limit that a namespace may consume
         * *limitRange*: defines minimum and maximum range of resources that a single entity can consume in a nameSpace  

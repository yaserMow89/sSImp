Pod Networking
==============

### Networking at the *POD* Layer
- No builtin solutions as of today
   - But lays down the **requirements** for pod networking
      - Every pod should have an **IP Address**
      - Every pod should be able to communicate with every other pod
      - Every pod should be able to reach other pods on other nodes without NAT
   - Many networking solutions available that address above requirements
- How can we tackle the issue at hand (above)
- If we try to solve it by **ourselves**:
   - Nodes are part of external network and have ip of `192.168.1.0/24`
      - `node1` is `192.168.1.11`
      - `node2` is `192.168.1.12`
      - `node3` is `192.168.1.13`
   - Upon container creation, the k8s creates **NameSpaces** for them
      - In order to enable communication between these **NameSpaces** we have to attach them to a network
         - We can create a **Bridge** network on each node
            - Each with their own *subnet*
               - For example, bridges on `node1`, `node2` and `node3` respectively get the ips:
                  - `10.244.1.0/24` --> bridge interface ip `...1.1`
                  - `10.244.2.0/24` --> bridge interface ip `...2.1`
                  - `10.244.3.0/24` --> bridge interface ip `...3.1`
         - Now we can attach each container to the respective node bridge network
            - Same as earlier lectures:
               - Create the *pipe*
               - Attach one end to the *bridge* interface and one end to the *container*
               - Assign IP
               - Add a router for the *default gateway*
               - Bring up the interfaces
            - Can be repeated for every container we create
         - At this point, we have fulfilled the first two requirements:
            - The pods get IPs of their own
            - They are able to communicate with each other on the same host
         - Now we have to make sure they can reach each other on other nodes
            - We can configure routes on each of the hosts to the bridge networks on other hosts via the respective hosts
            - This works fine in a small environment, but is difficult to maintain when it comes to the bigger environments
            - We can achieve it, also by having a **router** in-between
               - Manage all the routing tasks from the router
   - Assume we have all of this scripted, how to run it whenever a new pod is created?
      - **CNI** tells k8s how it should call a script as soon as it creates a container
         - The script should also be modified to meet the **CNI** standards
            - Should contain an *`ADD`* section
            - Should contain a *`DEL`* section
         - Script is ran with the container name and namespace
            - `Schript.sh add <container> <namespace>`
            

ETCD in HA
==========

- Distributed
- `2379`
- Data Consistency across all nodes

## Ensuring Consistency
- Reads --> nothing to worry about
- Writes
   - What if two write requests come in on two different instances
   - Which goes through?
      - On instance 01 --> Name = john
      - On instance 03 --> Name = Joe
   - Writes doe not take place on all nodes, but only one instance is responsible for processing the writes
   - A write is only assumed to be completed once it is synced across all instances
   - What if a node *fails*?
      - A write is considered to be complete if it is written by the majority of the nodes in the cluster
      - If the failed node comes online, the data is going to be written on that as well
- **majority**
   - `N/2+1`
   - Also called as **Quorum**
      - Minimum number of nodes for the cluster to be available to function properly (Make a successful write)
   - **odd** number is recommended
      - Better chances of functioning, in case of network segmentation

- **Leader**
   - If the `writes` are coming to the *Leader* node --> get processed
      - Synced across other nodes
   - Not to the leader!
      - Gets forwarded to the *Leader* and synced

## Leader Election
- **RAFT** Protocol
- Random timers for initiating request
- First one to finish timer, sends out request to the other nodes for **Leadership Permissions**
   - Others give their votes
- Once a node is elected *leader*
   - Regular interval notifications, to other masters informing them that it is continuing to assume the role of leader
- In case the periodic notification is not received by other nodes, they initiate the **re-election** process among themselves

## Installation
- Download the `bin`
- Create the crt files
- Configure `etcd service`
   - Important: the option `initial-cluster`, should be used to pass the **Peers** information, so that each `etcd` node knows it is part of a cluster and knows where it's peers are
- `etcdctl` utility can be used to store and retrieve data
   - Has two *api** version: `v2` (default) and `v3`
      - Commands work differently in each of them
      - We will use `v3` so set the env var `ETCDCTL_API=3`
   - run `etcdctl put <key> <val>`
   - run `etcdctl get <key>`
   - run `etcdctl get / --prefix --keys-only` --> gives all keys

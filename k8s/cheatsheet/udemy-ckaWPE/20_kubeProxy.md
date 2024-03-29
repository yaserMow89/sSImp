Kubelet Proxy
=============

- Pod networking solution within the cluster
   - Pod network is a virtual network that spans across all the nodes on the cluster to which all the pods connect to
   - Through this network they are able to communicate with each other
   - Many solutions available for deploying such a network
- Runs on each node in the cluster
- Searches **Services** on each node, and if any new found:
   - Create the rules to forward traffic to those services to the backend pods
   - Does this by using **ipTables** rules
- How to **Install**
   1. **kubeadm**
      - Deploys it as pod on each node
   2. Can also be done manually

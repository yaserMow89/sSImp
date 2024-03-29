Kubelet
=======


- The sole **point of contact** from the master node
- **Registers** the node with a k8s cluster
- **Receives instructions** to load a container or pod, and requests the container runtime engine to pull the required image and run an instance of it
- **monitor** the state of the pods and containers within it, and reports to the *kube-apiserver* on a **timely** bases
- How to install it?
   - Using **Kubeadm** to deploy the cluster it doesn't automatically deploy the **kubelet**
      - Difference from other components
      - You have to download, install and run it as a service **manually** on the worker nodes
- The process and it's effective options can be seen by listing the process and searching for the **kubelet** on the **worker** nodes

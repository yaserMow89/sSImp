Kube-API Server
===============
- Primary management utility in k8s
- When a `kubectl` is ran:
   1. It gets to *kube-api-server*
   2. It authenticates the request and then validates it
   3. Then retrieves the data from *etcd* cluster
   4. Gets back the requested info to the `kubectl`
- Above process can also be done, without using `kubectl`
- Lets look at an example of creating a pod, as in previous method (using `kubectl`):
   1. Steps 1 and 2 happens from the previous section first
   2. *kube-api-server* creates a pod object without assigning it to a node
   3. Updates the info in the *etcd*
   4. Updates the user that the pod has been created
   5. The *scheduler* continuously monitors the *kube-api-server* and sees there is a new pod object without a node
   6. It identifies the right node to place the pod on, and communicates it back to the *kube-api-server*
   7. *kube-api-server* updates the *etcd*
   8. The *kube-api-server* then passes the information to the *kubelet* in the appropriate worker node
   9. The *kubelet* then creates the pod on the node and instructs the *container run time engine* to deploy the application image
   10. Once done, *kubelet* updates the status back to the *kube-api-server*
   11. *kube-api-server* updates the data in *etcd* cluster
- A similar pattern is followed every time a change is requested
- *kube-api-server* is the only component that interacts directly with *etcd* data store

- To see at different options for `etcd`, `kube-apiserver` or other components in a cluster, it depends on how you have set up your cluster:
   1. using `kubeadm`:
      - In this case most of the options should be in: `/etc/kubernetes/manifests/`
      - Or on the master node you can search for the process and find the effective options passed with it
         `ps aux | grep kube-apiserver`
   2. Non `kubeadm` setup:
      - On the respective server look for the respective service in the `/etc/systemd/system/<serviceName>.service`

Setting up the env
==================

- get the servers up and running
- set appropriate hostnames
- config static DNS on them, so they can talk to each other
- Install *containerd* on all of them
   * Enable some kernel modules:
```
cat << EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF
```
   * Make some configuration changes to the networking:
```
cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF
```
   * Make them effective immediately:
   ```
   sudo sysctl --system
   ```
   * Install *containerd*:
   ```
   sudo apt-get update && sudo apt-get install -y containerd
   ```
   * Setup *containerd* configuration file:
   ```
   sudo mkdir -p /etc/containerd
   ```
   * Generate the contents of the configuration file:
   ```
   sudo containerd config default | sudo tee /etc/containerd/config.toml
   ```
   * To make sure the *containerd* is using the config file, just restart the *containerd*:
   ```
   sudo systemctl restart containerd
   ```
   * Disable **Swap* (K8S doesn't work with it)
   ```
   sudo swapoff -a
   ```
   * Install some packages required to be installed:
   ```
   sudo apt-get update && sudo apt install -y apt-transport-https curl
   ```
   * Add gpg keys:
   ```
   # If the folder `/etc/apt/keyrings` does not exist, it should be created before the curl command, read the note below.
   # sudo mkdir -p -m 755 /etc/apt/keyrings
   curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
   ```
   * Add k8s package repository:
   ```
   echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
   ```
   * Update the repos: `sudo apt update`
   * Install the packages: `sudo apt install kubelet kubeadm kubectl`
   * Avoid any automatic upgrades on them `sudo apt-mark hold kubelet kubeadm kubectl`
   * Repeat the same process on the worker nodes also, starting with *Enable some kernel modules*

### Cluster specific tasks:
   1. on the master node run the following to initialize the cluster:
   ```
   sudo kubeadm init --pod-network-cidr 192.168.0.0/16
   ```
      * You need at least 2 cpu cores and 1700MB of RAM on a node to start a cluster on it
   2. Now we need to setup our *kubeconfig*
      * *kubeconfig* is a file, that allows to authenticate and interact with the cluster using `kubectl` command and commands that we need,
      * The config is also part of the step 1 output, in our case it is:
      ```
      mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
   ```
      * At this point you should be able to at least interact with the cluster on the *master node*
         * For example check for all the nodes inside the cluster:
            * `kubectl get nodes`
   3. Installing the netowrking plugin:
      * We are going to proceed with *calico*, though there are also others available
      ```
      kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/calico.yaml
      ```
   4. Joining the Nodes
      * we can print the joining data and command using:
      ```
      kubeadm token create --print-join-command
      ```
   5. Join the nodes on to the cluster, run the command that you got in step 4 as sudo
      * if you get the error:
```
[ERROR FileContent--proc-sys-net-bridge-bridge-nf-call-iptables]: /proc/sys/net/bridge/bridge-nf-call-iptables does not exist
```
      * run the following commands to fix it:
```
sudo modprobe br_netfilter
sudo echo 1 > /proc/sys/net/bridge/bridge-nf-call-iptables
sudo echo 1 > /proc/sys/net/ipv4/ip_forward
```
      * And then try joining once again
   6. If the joining has been successful, you should see the worker nodes on the control plane using `kubectl` command

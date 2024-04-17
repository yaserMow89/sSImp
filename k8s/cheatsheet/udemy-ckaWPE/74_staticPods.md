Static Pods
===========

- *Kubelet* node management independently
   - *kubelet* can be configed to read pod definition files from a directory on the server designated to store information about pods
   - `/etc/kubernetes/manifests`
   - *kubelet* periodically reads this directory for files and *creates* the pods, also *ensures* that pod stays alive
   - If a pod crashes --> *kubelet* attemtps to restart it
   - Changes to the file in the directory, *kubelet* recreates the pod to reflect changes
   - If you remove a file from this directory the pod is also removed automatically
- Only pods can be created as static
   - *kubelet* works at a pod level, and can only understand pods
- The directory is given as:
- `pus aux | grep -i kubelet`
- Usually it is at `/var/lib/kubelet/config.yaml`
```
kubelet.serviceFile:
   --pod-manifest-path=/etc/Kubernetes/manifests
```
- Also another way to configure this
   - We can define a config file for `kubelet.service` file and then define it inside that file
      - For example:
      ```
      --config=kubeconfig.yaml
      ```
      - Inside the file:
      ```
      staticPodPath: <path/to/the/file>
      ```
- can be viewed by the `docker ps` command
   - Cause `kubectl` is not managing it, it is `kubelet`
- Basically `kubelet` takes input from two sources:
   1. `--pod-manifest-path` --> For static pods
   2. `kube-API-Server`
      - Also knows about the static pods created by the `kubelet`
      - It is because of the **Mirror Object** in the kube-api-server
         - What you see in the kube-api-server is only the **readOnly** mirror of the pod
            - Can only view the details of the pod, no editing or deletion
      - Deletion is only possible via the `pod-mainfest-files`
      - Name of the pod is automatically appended with the node's name

## Use Case
   - Can be used to deploy *Control-plane* components as pods on the nodes
   - How this works?
      1. Install `kubelet` on all master nodes
      2. Create Pod definition files that uses docker images of various control plane components
      3. Place the definition files in the designated `pod-manifest-file`
      4. `kubelet` will take care of it automatically
      - If any of them crashes `kubelet` will restart them or deploy new ones to keep them alive
   - This is the way the `kubeadmin` sets up clusters, and that is why components are seen as pods in the `kube-system` *namespace*

## Static Pods Vs Daemon Sets
   * Static Pods
      1. Created by `kubelet`
      2. Deploy *control plane* components as static pods

   * DaemonSets
      1. Created by `kube-API` server
      2. Deploy Monitoring Agents, Logging Aggents on nodes
   - Both are ignored by *kube-scheduler*

## Useful commands
   - `k get pod <podName> -o yaml`
      - You will find in the `ownerReference` section
      - And if you see the `kind: Node`, then you know that it is a static pod
   - **Running a command** inside a pod:
      `k run <podName> --image=<imageName> --restart=Never --dry-run=client -o yaml --command -- <firstCommand> <secondCommand> ... > <outputFile.yml>`
         - Make sure that you don't put anything after the `--command --`, cuase anything after it would be considered a command

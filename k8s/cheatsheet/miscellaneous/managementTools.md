K8S Management Tools:
=====================

## `kubectl`
This document is written based on kubernetes official documentation; available via this [link](https://kubernetes.io/docs/reference/kubectl/)

- For communicating with k8s *Control Plane* nodes using *k8s API*
- `kubectl` config file is at `$HOME/.kube`
   - Other config file can also be set by setting the `KUBECONFIG` env var or using `-kubeconfig` flag

- Syntax is:
```
kubectl [command] [TYPE] [NAME] [flags]
```
   - `command`:
      * `delete`, `create`, `describe`, `delete`
   - `TYPE`: Resource type
      * *case-insensitive*
      * *singular* or *plural*
      * *abbreviated form*
      * Example:
```
kubectl get pod pod1
kubectl get pods pod1
kubectl get po pod1
```
   - `NAME`: Resource's name, no name == all reources
      * One or more resources with the same type:
      ```
      kubectl get pods pod1 pod2
      ```
      * One or more resources with the different types:
      ```
      # kubectl get <resourc>/<resourceName> <differentResource>/<resourceName> ...
      # An example would be:
      kubectl get pods/pod1 replicationcontroller/rc1
      ```

## `kubeadm`
This document is written based on kubernetes official documentation; available via this [link](https://kubernetes.io/docs/reference/setup-tools/kubeadm/)
   - Tool as best-practice "fast-paths" for creating k8s clusters
   - Minimum viable cluster up and running
   - Cares only about *bootstrapping*

## `minikube`

## Helm
The following content are taken from this [link](https://www.youtube.com/watch?v=fy8SHvNZGeE)
   - Package manager for k8s
   - easing the services and applications deployments to k8s cluster
   - Using k8s yaml file, you would define the services, applications, deployments and everything
   - But **Helm**:
      - Logically separating the configuration for whole application stack from applications' templates
      - Combining two particular components for the whole application stack:
         * Configuration
         * Template (Known as chart in helm)
            * Chart consists of all files that we are going to template them
            * How we template files and inject variables into them?
               * Take the configuration and use templating language to decide where the configuration values should be placed inside your templates or charts
      - For **Helm** to work, **Tiller** is also required on the k8s also
      - *Version History*
      - *Helm Repos*

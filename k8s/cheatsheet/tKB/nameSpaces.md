NameSpaces - tKB
================
* Throughout this file **namespaces** refers to the Kernel namespaces and **Namespaces** refers to the K8S Namespaces

#### Kernel namespaces vs K8S Namespaces:
   - namespaces: partition OSs into virtual OSs called containers
   - Namespaces: partition K8S clusters into virtual clusters called Namespaces

### Namespaces:
   - Soft isolation --> soft *multi-tenancy*
      * For example Namespaces for:
         * **dev**
         * **test**
         * **qa**
         * A compromised workload in one Namespaces won't impact workloads in other Namespaces
   - To see if objects are namespaced or not `kubectl api-resources`
      * unNamespaced objects are **cluster-scoped** and cannot be isolated to Namespaces

#### Namespaces use cases:
   - A way for multiple tenants to share the same cluster
      - Tenant is a loose term; can refer to individual applications, different teams or departments, and even external customers.
      - It is up to you on how you implement Namespaces and what is considered to be a tenant
      - But it is most common to divide clusters by Namespaces for internal use, for example by Organizational Structure:
         1. finance --> finance apps
         2. hr --> hr apps
         3. corporate-ops --> corporate apps
      - Dividing a cluster among external tenants by using Namespaces isn't common

- To see a list of your Namespace `kubectl get namespaces`
   1. **default** --> where new objects go if you don't specify a Namespace when creating them
   2. **kube-system** --> where *control plane* components such as the internal DNS service and the metrics server run
   3. **kube-public** --> Objects that need to be readable by anyone
   4. **kube-node-lease** --> Node heartbeat and managing node leases

- To inspect a Namespace on the cluster `kubectl describe ns <NamespaceName>`
- To filter results against a specific Namespace you can use `-n` or `--namespace` to `kubectl` commands
   * For example to list all service objects in the **kube-system** Namespace `kubectl get svc --namespace kube-system`
   * `--all-namespaces` flag can be used to return objects across **All Namespaces**
- Creating one `kubectl create ns <Name>` --> Imperative
- Creating using `yaml` --> Declarative
- Deleting one `kubectl delete ns <Name>` --> Imperative
- Deleting using `yaml` --> Declarative
- **Config a *default* Namespace for all your commands** `kubectl config set-context --current --namespace <NamespaceName>`
   * To get the **current** default Namespace `kubectl config view --minify`
   * **NOTE** If you have just created you Namespace and switched to it as the default and now if you do `kubectl get nodes` you will see all the nodes inside the cluster, it is because **nodes** are cluster wide objects, and they don't belong to any Namespaces; so doesn't make any differences which Namespace are you in, they are visible on all
      * You can run `kubectl api-resources` to see which resources can be given to Namespaces and which ones can't
- **Deploying** objects into specific Namespaces:
   - `kubectl create -f <fileName> -n <NamespaceName>` or `--namespace <NamespaceName>` --> **Imperatively**
   - Specify with `yaml` --> **Declaratively**

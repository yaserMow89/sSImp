High Availability in K8S
========================
- Multiple **Master** nodes
- Redundancy across every component in the cluster
   - Avoid Single point of failure
   - Master nodes, worker nodes, control plane component, the application

## Master and Control plane Components
- Master node hosts control plane components
   - API
   - Controller Manager
   - Scheduler
   - ETCD
- HA Setup additional **master** node
   - Same Components running on the new master as well
- So how it works?
   - **API** Server
      - Receiving requests and processing them, providing information about the cluster
      - One request at a time
      - Can be alive and running at the same time on all nodes, in **ACTIVE ACTIVE** mode
      - `kubectl` talks to the API
         - Reaches api at `https://master:6443`
            - port `6443` is where API server listens and is configured in kube config file
         - But with two masters, where to point the `kubectl` to?
            - Should send the request to either one of them, but not both
               - Can be done using a **loadBalancer** in front of the master nodes
                  - Can be `nginx` or any other loadBalancer
   - **Controller Manager** and **Scheduler**
      - If more than one is running at a time, duplicate actions resulting in more pods than actually needed
         - Must not run in parallel
         - Should run in **ACTIVE STANDBY** mode
            - Who decides for the *Active* one and *passive (standby)* ones
               - **Leader Election Process**
                  - Is configured in `controller-manager` manifest file with option `--leader-elect`
                  - When `controller-manager` process starts tries to gain a `lease` or a `lock` on an endpoint object in k8s named as `kube-controller-manager Endpoint` whichever process first updates the endpoint with this information gains the lease and becomes the **ACTIVE**, others become **PASSIVE**
                  - The lock is held for the lease duration specified using the `--leader-elect-lease-duration` option (default is `15` seconds)
                  - The **ACTIVE** Process  renews the lease every `10` seconds (Default), can be set by option `--leader-elect-renew-deadline`
                  - All the processes try to become leader every `2` seconds (Default), can be set by option `--leader-elect-retry-period`
      - Controller Manager
         - Constantly watching the state of pods and taking necessary actions
      - Scheduler

   - **ETCD**
      - Two topoligies that can be configured in k8s
         1. **Stacked** topology (Stacked control plane topology)
            - `etcd` part of k8s *master* nodes
            - Easier to setup and manage
            - Risk during Failures
         2. **EXTERNAL** `etcd` Topology
            - Less risky
            - Harder to setup
            - More Servers
      - Only component talking to `etcd` is `api-server`
         - It knows where to talk to the `etcd` specified by options at it's manifest file `/etc/kubernetes/manifests/kube-apiserver.yaml` with option `--etcd-servers`
      - `etcd` is a distributed system
         - `api-server` or any other components wishing to talk to it, can reach to it at any of it's instances
